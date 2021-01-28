#!/usr/bin/env bash

APP=webhook-manager
S2I_IMAGE=redhat-openjdk18-openshift:1.4

. ../../../env.sh

oc login https://${IP}:8443 -u $USER

oc project ${CICD_PROJECT}

oc delete all -l app=${APP} -n ${CICD_PROJECT}
oc delete pvc -l app=${APP} -n ${CICD_PROJECT}
oc delete is,bc,dc,svc,route ${APP} -n ${CICD_PROJECT}
oc delete template ${APP}-dev-dc -n ${CICD_PROJECT}
oc delete configmap ${APP}-config -n ${CICD_PROJECT}

echo Setting up ${APP} for ${CICD_PROJECT}
oc new-build --binary=true --labels=app=${APP} --name=${APP} ${S2I_IMAGE} -n ${CICD_PROJECT}
oc new-app -f ../ocp/${APP}-dev-dc.yaml --allow-missing-imagestream-tags=true -n ${CICD_PROJECT}
oc set volume dc/${APP} --add --name=${APP}-config-vol --mount-path=/config --configmap-name=${APP}-config -n ${CICD_PROJECT}
oc expose dc ${APP} --port 8080 -n ${CICD_PROJECT}
oc expose svc ${APP} -l app=${APP} -n ${CICD_PROJECT}

