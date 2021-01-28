#!/usr/bin/env bash

IP=ocp.datr.eu
#IP=192.168.33.10

PROJECT=cicd
APP=jenkins-build-tools
BASE_IMAGE_VERSION_TAG=v3.11.69-3

oc  project $PROJECT

oc delete is,sa,svc,route,bc,dc -l app=${APP}
oc delete secret gitsecret
oc delete rolebinding jenkins_edit
oc delete pvc jenkins

oc create secret generic gitsecret \
    --from-file=ssh-privatekey=$HOME/.ssh/id_rsa \
    --type=kubernetes.io/ssh-auth

oc secrets link builder gitsecret

oc annotate secret sshsecret 'build.openshift.io/source-secret-match-uri-1=git@github.com:justindav1s/*'

oc new-app -f jenkins-master-s2i-template.yaml \
    -p SOURCE_REPOSITORY_URL=git@github.com:justindav1s/microservices-on-openshift.git \
    -p SOURCE_REPOSITORY_REF=master \
    -p CONTEXT_DIR=cicd_tools/custom-jenkins/master \
    -p MEMORY_LIMIT=1Gi \
    -p JENKINS_PASSWORD=changeme \
    -p VOLUME_CAPACITY=10Gi \
    -p GIT_SRC_SECRET=gitsecret \
    -p PROJECT=${PROJECT} \
    -p BASE_IMAGE_VERSION_TAG=${BASE_IMAGE_VERSION_TAG}

sleep 3

oc logs -f bc/jenkins