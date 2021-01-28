#!groovy

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

    stage('Checkout Source') {
        git url: "${git_url}", branch: 'master'
    }

    stage('Check Maven Version') {           
            sh "${mvn} -version"
            echo "GRAALVM_HOME : ${GRAALVM_HOME}"
            echo "PATH : ${PATH}"
    }

    def commitId  = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
    def commitmsg  = sh(returnStdout: true, script: "git log --format=%B -n 1 ${commitId}").trim()

    dir("${src_root}/${app_name}") {

        groupId      = getGroupIdFromPom("pom.xml")
        artifactId   = getArtifactIdFromPom("pom.xml")
        version      = getVersionFromPom("pom.xml")
        packaging    = getPackagingFromPom("pom.xml")

        stage ('Maven native build'){
            echo 'Building and test native binary'
            sh "${mvn} package -Pnative -DskipTests"   
        }

         //Build the OpenShift Image in OpenShift and tag it.
        stage('Build and Tag OpenShift Image') {
            echo "Building OpenShift container image ${app_name}:${devTag}"
            echo "Project : ${dev_project}"
            echo "App : ${app_name}"
            echo "Group ID : ${groupId}"
            echo "Artifact ID : ${artifactId}"
            echo "Version : ${version}"
            echo "Packaging : ${packaging}"

            sh "ls -ltr target"

            openshift.withCluster() {
                openshift.withProject("${dev_project}") {

                    echo "Building ...."
                    def bc = openshift.selector( "bc/${app_name}-native" ).object()
                    bc.spec.output.to.name="${registry}/${app_name}-native:${commitId}"
                    openshift.apply(bc)

                    def nb = openshift.startBuild("${app_name}-native", "--from-dir=.")
                    nb.logs('-f')

                }
            }
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