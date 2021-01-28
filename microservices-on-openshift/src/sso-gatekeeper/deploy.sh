#!/usr/bin/env bash

oc login https://ocp.datr.eu:8443 -u justin

APP=sso-gatekeeper
PROJECT=amazin-dev

oc project $PROJECT

oc delete deploymentconfig ${APP}
oc delete serviceaccounts ${APP}-sa
oc delete service ${APP}
oc delete route ${APP}
oc delete configmap ${APP}-config --ignore-not-found=true -n ${PROJECT}

oc new-app -f gatekeeper-template.yml \
    -p APPLICATION_NAME=${APP}

oc create configmap ${APP}-config --from-file=config/gatekeeper.yaml -n ${PROJECT}