#!/usr/bin/env bash

APP=inventory
IMAGE_NAME=${APP}
IMAGE_TAG=0.0.1-SNAPSHOT
SAP=v1
APP_SA=${APP}-sa

. ../../env.sh

oc login https://${IP}:8443 -u $USER

oc project ${PROD_PROJECT}

oc delete sa ${APP_SA}
oc delete template spring-boot-prd-template
oc delete deployments -l app=${APP} -n ${PROD_PROJECT}
oc delete deploymentconfigs -l app=${APP} -n ${PROD_PROJECT}
oc delete po -l app=${APP} -n ${PROD_PROJECT}
oc delete builds -l app=${APP} -n ${PROD_PROJECT}
oc delete svc -l app=${APP} -n ${PROD_PROJECT}
oc delete bc -l app=${APP} -n ${PROD_PROJECT}
oc delete routes -l app=${APP} -n ${PROD_PROJECT}
oc delete configmap ${APP}-config --ignore-not-found=true -n ${PROD_PROJECT}

