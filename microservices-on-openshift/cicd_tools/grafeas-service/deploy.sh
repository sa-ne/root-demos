#!/usr/bin/env bash

. ../env.sh

oc login https://${IP}:8443 -u justin

APP=grafeas-service

oc project $CICD_PROJECT

oc delete imagestream ${APP}
oc delete buildconfig ${APP}-docker-build
oc delete deploymentconfig ${APP}
oc delete serviceaccounts ${APP}
oc delete service ${APP}
oc delete route ${APP}

mvn clean package

oc new-app -f app-template.yml \
    -p APPLICATION_NAME=${APP} \
    -p SOURCE_REPOSITORY_URL=https://github.com/justindav1s/microservices-on-openshift.git \
    -p SOURCE_REPOSITORY_REF=master \
    -p DOCKERFILE_PATH="cicd_tools/grafeas-service" \

#oc logs -f bc/grafeas-service-docker-build

oc start-build ${APP}-docker-build  --from-dir=. --follow
