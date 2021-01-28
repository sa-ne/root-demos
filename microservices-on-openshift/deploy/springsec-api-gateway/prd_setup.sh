#!/usr/bin/env bash

APP=spring-api-gateway
ENV=prd
IMAGE_NAME=${APP}
IMAGE_TAG=0.0.1-SNAPSHOT
SPRING_PROFILES_ACTIVE=prd
VERSION_LABEL=v1
SERVICEACCOUNT_NAME=${APP}-${ENV}-sa
SERVICE_NAME=${APP}-${ENV}

. ../../env.sh

oc login https://${IP}:8443 -u $USER

oc project ${PROD_PROJECT}

oc delete dc ${APP}-${VERSION_LABEL} -n ${PROD_PROJECT}
oc delete deployments ${APP}-${VERSION_LABEL} -n ${PROD_PROJECT}
oc delete svc ${SERVICE_NAME} -n ${PROD_PROJECT}
oc delete sa ${SERVICEACCOUNT_NAME} -n ${PROD_PROJECT}

oc delete configmap ${APP}-${SPRING_PROFILES_ACTIVE}-config --ignore-not-found=true -n ${PROD_PROJECT}
oc create configmap ${APP}-${SPRING_PROFILES_ACTIVE}-config --from-file=../../src/api-gateway/src/main/resources/config.${SPRING_PROFILES_ACTIVE}.properties -n ${PROD_PROJECT}

oc secrets link ${SERVICEACCOUNT_NAME} nexus-dockercfg --for=pull -n ${PROD_PROJECT}

oc new-app -f ../service-template.yaml \
    -p APPLICATION_NAME=${APP} \
    -p SERVICEACCOUNT_NAME=${SERVICEACCOUNT_NAME} \
    -p SERVICE_NAME=${SERVICE_NAME}

sleep 2

oc policy add-role-to-group system:image-puller system:serviceaccounts:${PROD_PROJECT} -n ${DEV_PROJECT}
oc policy add-role-to-group system:image-puller system:serviceaccounts:${SERVICEACCOUNT_NAME} -n ${DEV_PROJECT}

oc secrets link ${SERVICEACCOUNT_NAME} nexus-dockercfg --for=pull -n ${PROD_PROJECT}

sleep 2

oc new-app -f ../spring-boot-prd-deploy-template.yaml \
    -p APPLICATION_NAME=${APP} \
    -p IMAGE_NAME=${IMAGE_NAME} \
    -p IMAGE_TAG=${IMAGE_TAG} \
    -p SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE} \
    -p VERSION_LABEL=${VERSION_LABEL} \
    -p SERVICEACCOUNT_NAME=${SERVICEACCOUNT_NAME}

oc set triggers dc/${APP}-${VERSION_LABEL} --remove-all
