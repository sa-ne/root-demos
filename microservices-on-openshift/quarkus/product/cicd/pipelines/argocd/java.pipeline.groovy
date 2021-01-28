#!groovy
//import groovy.transform.Field

node('maven') {

    def mvn          = "/opt/apache-maven-3.6.3/bin/mvn -U -B -q -s settings.xml"
    def sonar_url    = "http://sonarqube.cicd.svc:9000"
    def nexus_url    = "http://nexus.cicd.svc:8081/repository/maven-snapshots"
    def groupId, version, packaging = null
    def artifactId = null
    def github_repo  = sh (returnStdout: true, script: "echo $git_url | awk '{split(\$0,a,\"[/.]\"); print a[6]}' | tr -d '\n'") 
    sh "git config --global user.email \"justinndavis@gmail.com\""
    sh "git config --global user.name \"Justin Davis\""
    sh "git config --global push.default matching"

    stage('Repo Clone') {
        git url: "${git_url}", branch: 'master'
    }

    def commitId  = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
    def commitmsg  = sh(returnStdout: true, script: "git log --format=%B -n 1 ${commitId}").trim()

    dir("${src_root}") {

        groupId      = getGroupIdFromPom("pom.xml")
        artifactId   = getArtifactIdFromPom("pom.xml")
        version      = getVersionFromPom("pom.xml")
        packaging    = getPackagingFromPom("pom.xml")

        stage('Build jar') {
            echo "Building version : ${version}"
            sh "${mvn} clean package"
        }

        // Using Maven run the unit tests
        stage('Unit/Integration Tests') {
            echo "Running Unit Tests"
            sh "${mvn} test"
            archive "target/**/*"
            junit 'target/surefire-reports/*.xml'
        }

        stage('Coverage') {
            echo "Running Coverage"
            sh "${mvn} clean install org.jacoco:jacoco-maven-plugin:prepare-agent"
        }

        // Using Maven call SonarQube for Code Analysis
        stage('Code Analysis') {
            echo "Running Code Analysis"
            sh "${mvn} sonar:sonar -Dspring.profiles.active=dev -Dsonar.host.url=${sonar_url}"
        }

        //Publish the built war file to Nexus
        stage('Publish to Nexus') {
            echo "Publish to Nexus"
            sh "${mvn} deploy -DskipTests -Dquarkus.package.uber-jar=true"
        }

        //Build the Container Image in OpenShift, tag it and send it to a registry.
        stage('Build and Tag OpenShift Image') {
            echo "Building OpenShift container image ${app_name}:${commitId}"
            echo "Build namespace : ${build_namespace}"
            echo "App : ${app_name}"
            echo "Group ID : ${groupId}"
            echo "Artifact ID : ${artifactId}"
            echo "Version : ${version}"
            echo "Packaging : ${packaging}"

            sh "cp target/${artifactId}-*runner.${packaging} ."
            sh "cp ${artifactId}-*runner.${packaging} ${artifactId}-${commitId}.${packaging}"
            sh "pwd && ls -ltr"

            openshift.withCluster() {
                openshift.withProject("${build_namespace}") {

                    echo "Building ...."
                    def bc = openshift.selector( "bc/${app_name}" ).object()
                    bc.spec.output.to.name="${registry}/${app_name}:${commitId}"
                    openshift.apply(bc)

                    def nb = openshift.startBuild("${app_name}", "--from-file=${artifactId}-${commitId}.${packaging}")
                    nb.logs('-f')

                }
            }

        }

        // make updates to the Git repo, commit them and push them.
        stage('Update Repo') {
            sh "sed -i.bak 's/config.test.data.1=val1/config.test.data.1=val2/' argocd/plain-yaml/configmap.yaml"
            sh "echo \"    lastCommit=${commitId}\" >> argocd/plain-yaml/configmap.yaml"
            sh "cat argocd/plain-yaml/configmap.yaml"
            sh "yq w -i argocd/plain-yaml/deployment.yaml 'spec.template.spec.containers[0].image' ${registry}/${app_name}:${commitId}"

            withCredentials([usernamePassword(credentialsId: 'GIT', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                sh "git add .."
                sh "git status"
                sh "git commit -m \"updated by Jenkins\" || true"
                def origin = "https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/${github_repo}.git"
                sh "git push ${origin} master || true"
            }
        }

        // Trigger ArgoCD to sync the repo with openshift.
        stage('Argocd Sync') {
            echo "ArgoCD Parameters"
            echo "ARGOCD_USER : ${ARGOCD_USER}"
            echo "ARGOCD_SERVER : ${ARGOCD_SERVER}"
            sh "argocd --insecure login --username ${ARGOCD_USER} --password ${ARGOCD_PASSWORD} ${ARGOCD_SERVER}" 
            sh "argocd --insecure app sync ${argo_app_name}"          
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