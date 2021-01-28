#!/usr/bin/env bash

APP=web
S2I_IMAGE=openshift/nginx:1.10
. ../../env.sh

oc delete all -l app=${APP} --ignore-not-found=true -n ${DEV_PROJECT}
oc delete pvc -l app=${APP} --ignore-not-found=true -n ${DEV_PROJECT}
oc delete is,bc,dc,svc,route ${APP} --ignore-not-found=true -n ${DEV_PROJECT}
oc delete configmap ${APP}-config --ignore-not-found=true -n ${DEV_PROJECT}

echo Setting up ${APP} for ${DEV_PROJECT}
oc new-build --binary=true --strategy=source --labels=app=${APP} --name=${APP} --image-stream=${S2I_IMAGE} -n ${DEV_PROJECT}
oc new-app -f ${APP}-dev-template.yaml -n ${DEV_PROJECT}
