#!/usr/bin/env bash

#export IP=192.168.0.91
#export IP=ocp.datr.eu
#export IP=master.aws.datr.eu
export IP=api.ocp4.datr.eu:6443
#export IP=api.crc.testing:6443
#export IP=api.shared-rhpds.rhpds.openshift.opentlc.com:6443
export USER=justin
#export USER=jusdavis-redhat.com

export ORG=amazin
export DEV_PROJECT=${ORG}-dev
export PROD_PROJECT=${ORG}-prod
export CICD_PROJECT=cicd

export CURL="curl -k -v"
export JENKINS_USER=justin-admin-edit-view
export JENKINS_TOKEN=11cfdd54b08dd0fd51edf2ed87269d8fe6
export JENKINS=jenkins-cicd.apps.ocp4.datr.eu
#export JENKINS=jenkins-cicd.apps-crc.testing
#export JENKINS=jenkins-cicd.apps.${IP}


#export REGISTRY=nexus3-docker-cicd.apps-crc.testing
export REGISTRY=nexus3-cicd.apps.ocp4.datr.eu
export QUAYIO_REGISTRY=quay.io

export DOMAIN=$CICD_PROJECT
export DATABASE_USER="sonar"
export DATABASE_PASSWORD="sonar"
export DATABASE_URL="jdbc:postgresql://postgresql/sonar"

