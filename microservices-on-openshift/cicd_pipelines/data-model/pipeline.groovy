#!groovy

node('maven') {

    stage('Checkout Source') {
        git url: "${git_url}", branch: 'master'
    }

    dir('src/data-model') {

        def mvn          = "mvn -U -B -q -s ../settings.xml -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true"
        def dev_project  = "${org}-dev"
        def prod_project = "${org}-prod"
        def groupId      = getGroupIdFromPom("pom.xml")
        def artifactId   = getArtifactIdFromPom("pom.xml")
        def version      = getVersionFromPom("pom.xml")
        def packaging    = getPackagingFromPom("pom.xml")
        def sonar_url    = "http://sonarqube.cicd.svc:9000"

        stage('Build jar') {
            echo "Building version : ${version}"
            sh "${mvn} clean package -DskipTests"
        }

        // Using Maven run the unit tests
        stage('Unit Tests') {
            echo "Running Unit Tests"
            sh "${mvn} test"
        }

//        // Using Maven call SonarQube for Code Analysis
//        stage('Code Analysis') {
//            echo "Running Code Analysis"
//            sh "${mvn} sonar:sonar -Dsonar.host.url=${sonar_url}"
//        }

        // Publish the built war file to Nexus
        stage('Publish to Nexus') {
            echo "Publish to Nexus"
            sh "${mvn} deploy -DskipTests"
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