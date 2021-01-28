#!/usr/bin/env bash

#set -x

APP=sso-gatekeeper-inventory
. ../../../env.sh

oc login https://${IP}:8443 -u $USER

oc project ${DEV_PROJECT}

oc delete all -l app=${APP} -n ${DEV_PROJECT}
oc delete pvc -l app=${APP} -n ${DEV_PROJECT}
oc delete is,bc,dc,svc,route,sa ${APP} -n ${DEV_PROJECT}
oc delete sa ${APP}-sa -n ${DEV_PROJECT}
oc delete template spring-boot-gatekeeper-dev-template -n ${DEV_PROJECT}
oc delete configmap ${APP}-config -n ${DEV_PROJECT}
oc delete configmap ${APP}-gatekeeper-config -n ${DEV_PROJECT}

echo Setting up ${APP} for ${DEV_PROJECT}
oc new-app -f ../ocp/gatekeeper-sidecar-template.yaml \
    -p APPLICATION_NAME=${APP}

oc create configmap ${APP}-gatekeeper-config --from-file=../config/gatekeeper.yaml -n ${DEV_PROJECT}
oc create configmap ${APP}-config --from-file=../config/config.dev.properties -n ${DEV_PROJECT}