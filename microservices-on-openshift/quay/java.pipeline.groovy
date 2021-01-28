#!groovy

node('maven') {

    stage('Checkout Source') {
        git url: "${git_url}", branch: 'master'
    }

    dir("src/${app_name}") {

        def mvn          = "mvn -U -B -q -s ../settings.xml -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true"
        def dev_project  = "${org}-dev"
        def prod_project = "${org}-prod"
        def app_url_dev  = "http://${app_name}.${dev_project}.svc:8080"
        def groupId      = getGroupIdFromPom("pom.xml")
        def artifactId   = getArtifactIdFromPom("pom.xml")
        def version      = getVersionFromPom("pom.xml")
        def packaging    = getPackagingFromPom("pom.xml")
        def sonar_url    = "http://sonarqube.cicd.svc:9000"
        def nexus_url    = "http://nexus.cicd.svc:8081/repository/maven-snapshots"
        def registry     = "quay-enterprise-quay-enterprise.apps.ocp.datr.eu"
        def local_reg    = "docker-registry.default.svc:5000"

//        stage('Build jar') {
//            echo "Building version : ${version}"
//            sh "${mvn} clean package -Dspring.profiles.active=dev -DskipTests"
//        }
//
//        // Using Maven run the unit tests
//        stage('Unit/Integration Tests') {
//            echo "Running Unit Tests"
//            sh "${mvn} test -Dmaven.wagon.http.ssl.insecure=true -Dspring.profiles.active=dev"
//            archive "target/**/*"
//            junit 'target/surefire-reports/*.xml'
//        }
//
//        stage('Coverage') {
//            echo "Running Coverage"
//            sh "${mvn} clean org.jacoco:jacoco-maven-plugin:prepare-agent install -Dspring.profiles.active=dev"
//        }
//
//        // Using Maven call SonarQube for Code Analysis
//        stage('Code Analysis') {
//            echo "Running Code Analysis"
//            sh "${mvn} sonar:sonar -Dspring.profiles.active=dev -Dsonar.host.url=${sonar_url}"
//        }
//
//        // Publish the built war file to Nexus
//        stage('Publish to Nexus') {
//            echo "Publish to Nexus"
//            sh "${mvn} deploy -DskipTests"
//        }

        //Build the OpenShift Image in OpenShift and tag it.
        stage('Build and Tag OpenShift Image') {
            echo "Building OpenShift container image ${app_name}:${devTag}"
            echo "Project : ${dev_project}"
            echo "App : ${app_name}"
            echo "Group ID : ${groupId}"
            echo "Artifact ID : ${artifactId}"
            echo "Version : ${version}"
            echo "Packaging : ${packaging}"
            sh "${mvn} clean"
            sh "${mvn} dependency:copy -DstripVersion=true -Dartifact=${groupId}:${artifactId}:${version}:${packaging} -DoutputDirectory=."
            sh "cp \$(find . -type f -name \"${artifactId}-*.${packaging}\")  ${artifactId}.${packaging}"
            sh "pwd; ls -ltr"

            openshift.withCluster() {
                openshift.withProject("${dev_project}") {

                    echo "Patching to update build out put tag...."
                    def bc = openshift.selector( "bc/${app_name}" ).object()
                    bc.spec.output.to.name="${registry}/${dev_project}/${app_name}:${version}"
                    openshift.apply(bc)

                    echo "Building ...."
                    def nb = openshift.startBuild("${app_name}", "--from-file=${artifactId}.${packaging}")
                    nb.logs('-f')

                    echo "Patching to update build out put tag...."
                    bc = openshift.selector( "bc/${app_name}" ).object()
                    bc.spec.output.to.name="${registry}/${dev_project}/${app_name}:${env.BUILD_NUMBER}"
                    openshift.apply(bc)

                    echo "Building ...."
                    nb = openshift.startBuild("${app_name}", "--from-file=${artifactId}.${packaging}")
                    nb.logs('-f')

                    echo "Patching to update build out put tag...."
                    bc = openshift.selector( "bc/${app_name}" ).object()
                    bc.spec.output.to.name="${registry}/${dev_project}/${app_name}:latest"
                    openshift.apply(bc)

                    echo "Building ...."
                    nb = openshift.startBuild("${app_name}", "--from-file=${artifactId}.${packaging}")
                    nb.logs('-f')

//                    echo "Tagging ...."
//                    openshift.tag("--source=docker", "${registry}/${dev_project}/${app_name}:${version}", "${dev_project}/${app_name}:${version}", "--reference-policy=local")
//                    openshift.tag("--source=docker", "${registry}/${dev_project}/${app_name}:${version}", "${dev_project}/${app_name}:latest", "--reference-policy=local")
//                    openshift.tag("--source=docker", "${registry}/${dev_project}/${app_name}:${version}", "${dev_project}/${app_name}:${env.BUILD_NUMBER}", "--reference-policy=local")


                }
            }

        }

        // Deploy the built image to the Development Environment.
        stage('Deploy to Dev') {
            echo "Deploying container image to Development Project"
            echo "Project : ${dev_project}"
            echo "App : ${app_name}"
            echo "Dev Tag : ${devTag}"

            openshift.withCluster() {
                openshift.withProject(dev_project) {
                    //remove any triggers
                    openshift.set("triggers", "dc/${app_name}", "--remove-all");

                    //update deployment config with new image
                    openshift.set("image", "dc/${app_name}", "${app_name}=${registry}/${dev_project}/${app_name}:${version}")

                    //update app config
                    openshift.delete("configmap", "${app_name}-config", "--ignore-not-found=true")
                    openshift.create("configmap", "${app_name}-config", "--from-file=${config_file}")

                    //trigger a rollout of the new image
                    def rm = openshift.selector("dc", [app:app_name]).rollout().latest()
                    //wait for rollout to start
                    timeout(5) {
                        openshift.selector("dc", [app:app_name]).related('pods').untilEach(1) {
                            return (it.object().status.phase == "Running")
                        }
                    }
                    //rollout has started

                    //wait for deployment to finish and for new pods to become active
                    def latestDeploymentVersion = openshift.selector('dc',[app:app_name]).object().status.latestVersion
                    def rc = openshift.selector("rc", "${app_name}-${latestDeploymentVersion}")
                    rc.untilEach(1) {
                        def rcMap = it.object()
                        return (rcMap.status.replicas.equals(rcMap.status.readyReplicas))
                    }
                    //deployment finished
                }
            }
            echo "Deploying container image to Development Project : FINISHED"

        }

        stage("Wait for approval for ${app_name} to be staged into production") {
                timeout(time: 2, unit: 'DAYS') {
                    input message: "Approve this ${app_name} build to be staged in production ?"
                }
        }

        // Deploy the built image to the Development Environment.
        stage('Deploy to Production') {
            echo "Deploying container image to Production Project"
            echo "Project : ${prod_project}"
            echo "App : ${app_name}"
            echo "Prod Tag : ${prodTag}"

            openshift.withCluster() {


                openshift.withProject(dev_project) {
                    echo "Tagging .... Image for Production"
                    openshift.tag("${app_name}:${devTag}", "${app_name}:${prodTag}")
                }

                openshift.withProject(prod_project) {

                    def deployment  = "${app_name}-${prodTag}"

                    openshift.set("triggers", "dc/${deployment}", "--remove-all");

                    echo "Deploy .... Image to Production : ${deployment}"

                    //update deployment config with new image
                    openshift.set("image", "dc/${deployment}", "${app_name}=docker-registry.default.svc:5000/${dev_project}/${app_name}:${prodTag}")

                    //update app config
                    openshift.delete("configmap", "${app_name}-config", "--ignore-not-found=true")
                    openshift.create("configmap", "${app_name}-config", "--from-file=../../src/${app_name}/src/main/resources/config.${prodTag}.properties")

                    //trigger a rollout of the new image
                    def rm = openshift.selector("dc/${deployment}").rollout().latest()
                    //wait for rollout to start
                    timeout(5) {
                        openshift.selector("dc/${deployment}").related('pods').untilEach(1) {
                            return (it.object().status.phase == "Running")
                        }
                    }
                    //rollout has started
                }

            }
            echo "Deploying container image to Production Project : FINISHED"

        }
    }
}

// Convenience Functions to read variables from the pom.xml
// Do not change anything below this line.
// --------------------------------------------------------
def getVersionFromPom(pom) {
    def matcher = readFile(pom) =~ '<version>(.+)</version>'
    matcher ? matcher[0][1] : null
}
def getGroupIdFromPom(pom) {
    def matcher = readFile(pom) =~ '<groupId>(.+)</groupId>'
    matcher ? matcher[0][1] : null
}
def getArtifactIdFromPom(pom) {
    def matcher = readFile(pom) =~ '<artifactId>(.+)</artifactId>'
    matcher ? matcher[0][1] : null
}
def getPackagingFromPom(pom) {
    def matcher = readFile(pom) =~ '<packaging>(.+)</packaging>'
    matcher ? matcher[0][1] : null
}