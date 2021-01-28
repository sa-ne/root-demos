#!/usr/bin/env bash

. ./env.sh

APP=ocp-awscli
VERSION=1

oc login https://${IP}:8443 -u $USER

oc delete project $PROJECT
oc new-project $PROJECT 2> /dev/null
while [ $? \> 0 ]; do
    sleep 1
    printf "."
oc new-project $PROJECT 2> /dev/null
done

oc delete imagestream ${APP}
oc delete buildconfig ${APP}-docker-build
oc delete deploymentconfig ${APP}
oc delete persistentvolumeclaim ${APP}-data
oc delete persistentvolumeclaim ${APP}-extensions
oc delete serviceaccounts ${APP}
oc delete service ${APP}
oc delete route ${APP}


oc new-app -f ecr-cron-template.yml \
    -p APPLICATION_NAME=${APP} \
    -p VERSION="1" \
    -p SOURCE_REPOSITORY_URL=https://github.com/justindav1s/microservices-on-openshift.git \
    -p SOURCE_REPOSITORY_URL=master \
    -p DOCKERFILE_PATH="cicd_tools/ecr/refresh_job" \
    -p DOCKERFILE_NAME="Dockerfile.ocp"
