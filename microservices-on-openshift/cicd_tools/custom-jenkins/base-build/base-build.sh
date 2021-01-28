#!/usr/bin/env bash

IP=ocp.datr.eu
PROJECT=cicd
LABEL=jenkins-build-tools

IMAGE=datr-jenkins2
VERSION=v3.10

REG_USER=
REG_PASSWD=
REG_SECRET=
REG_HOST=

GIT_USER=
GIT_PASS=
GIT_REPO=

DOCKERFILE_PATH=base-build

#oc login https://${IP}:8443

oc  project $PROJECT

oc delete is,sa,svc,route,bc,dc,secret -l app=${LABEL}
oc delete secret ${REG_SECRET}

oc create secret docker-registry ${REG_SECRET} \
    --docker-server=${REG_HOST} \
    --docker-username=${REG_USER} \
    --docker-password=${REG_PASSWD} \
    --docker-email=no@email.local

oc new-app -f jenkins-base-build.yaml \
    -p NAME=${IMAGE} \
    -p VERSION=${VERSION} \
    -p SOURCE_REPOSITORY_URL=${BB_REPO} \
    -p GIT_USER=${BB_USER} \
    -p GIT_PASS=${BB_PASS} \
    -p REG_HOST=${REG_HOST} \
    -p REG_SECRET=${REG_SECRET} \
    -p DOCKERFILE_PATH=${DOCKERFILE_PATH}

sleep 2

oc logs -f bc/${IMAGE}