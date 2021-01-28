#!/usr/bin/env bash

. ./env.sh

oc login https://${IP}:8443 -u $USER

APP_NAME="kaniko"

oc delete pod ${APP_NAME}
oc delete sa ${APP_NAME}-sa

oc new-app  -f kaniko-run-template.yaml \
    -p APPLICATION_NAME=${APP_NAME}
