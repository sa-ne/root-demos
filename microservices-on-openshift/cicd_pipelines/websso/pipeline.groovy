#!groovy

node('nodejs') {

    stage('Checkout Source') {
      git url: "${git_url}", branch: 'master'
    }

    dir("src/${app_name}") {

      def dev_project  = "${org}-dev"
      def prod_project = "${org}-prod"
      def sonar_url    = "http://sonarqube.cicd.svc:9000"

      stage('npm') {
        sh 'cat src/environments/environment.ts'
        sh 'npm install'
      }


      stage('Dev : Angular build') {
        sh 'node_modules/.bin/ng build'
      }

      //Build the OpenShift Image in OpenShift and tag it.
      stage('Dev : Build and Tag OpenShift Image') {
        echo "Building OpenShift container image ${app_name}:${devTag}"
        echo "Project : ${dev_project}"
        echo "App : ${app_name}"

        sh "oc start-build ${app_name} --follow --from-dir=dist/Angular7 -n ${dev_project}"
        openshiftVerifyBuild apiURL: '', authToken: '', bldCfg: app_name, checkForTriggeredDeployments: 'false', namespace: dev_project, verbose: 'false', waitTime: ''
        openshiftTag alias: 'false', apiURL: '', authToken: '', destStream: app_name, destTag: devTag, destinationAuthToken: '', destinationNamespace: dev_project, namespace: dev_project, srcStream: app_name, srcTag: 'latest', verbose: 'false'
      }

      // Deploy the built image to the Development Environment.
      stage('Dev :  Deploy') {
        echo "Deploying container image to Development Project"
        echo "Project : ${dev_project}"
        echo "App : ${app_name}"
        echo "Dev Tag : ${devTag}"

        sh "oc set image dc/${app_name} ${app_name}=docker-registry.default.svc:5000/${dev_project}/${app_name}:${devTag} -n ${dev_project}"

        openshiftDeploy apiURL: '', authToken: '', depCfg: app_name, namespace: dev_project, verbose: 'false', waitTime: '180', waitUnit: 'sec'
        openshiftVerifyDeployment apiURL: '', authToken: '', depCfg: app_name, namespace: dev_project, replicaCount: '1', verbose: 'false', verifyReplicaCount: 'true', waitTime: '180', waitUnit: 'sec'
      }


      // stage('Prod : Angular build') {
      //   sh 'node_modules/.bin/ng build --prod'
      // }
      //
      // //Build the OpenShift Image in OpenShift and tag it.
      // stage('Prod : Build and Tag OpenShift Image') {
      //   echo "Building OpenShift container image ${app_name}:${prodTag}"
      //   echo "Project : ${prod_project}"
      //   echo "App : ${app_name}"
      //
      //   sh "oc start-build ${app_name} --follow --from-dir=dist/Angular7 -n ${dev_project}"
      //   openshiftVerifyBuild apiURL: '', authToken: '', bldCfg: app_name, checkForTriggeredDeployments: 'false', namespace: dev_project, verbose: 'false', waitTime: ''
      //   openshiftTag alias: 'false', apiURL: '', authToken: '', destStream: app_name, destTag: prodTag, destinationAuthToken: '', destinationNamespace: prod_project, namespace: dev_project, srcStream: app_name, srcTag: 'latest', verbose: 'false'
      // }

//      stage("Wait for approval for ${app_name} to be staged into production") {
//        timeout(time: 2, unit: 'DAYS') {
//          input message: "Approve this ${app_name} build to be staged in production ?"
//        }
//      }
//
//      // Deploy the built image to the Development Environment.
//      stage('Prod :  Deploy') {
//        echo "Deploying container image to Development Project"
//        echo "Project : ${prod_project}"
//        echo "App : ${app_name}"
//        echo "Prod Tag : ${prodTag}"
//
//        sh "oc set image dc/${app_name} ${app_name}=docker-registry.default.svc:5000/${prod_project}/${app_name}:${prodTag} -n ${prod_project}"
//
//        openshiftDeploy apiURL: '', authToken: '', depCfg: app_name, namespace: prod_project, verbose: 'false', waitTime: '180', waitUnit: 'sec'
//        openshiftVerifyDeployment apiURL: '', authToken: '', depCfg: app_name, namespace: prod_project, replicaCount: '1', verbose: 'false', verifyReplicaCount: 'true', waitTime: '180', waitUnit: 'sec'
//      }
    }
}
