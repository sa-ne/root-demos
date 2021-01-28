#!/usr/bin/env bash


. ../env.sh

oc login https://${IP} -u $USER

oc delete secret quayio-dockercfg -n $CICD_PROJECT
oc delete secret quayio-dockercfg -n $PROD_PROJECT
oc delete secret quayio-dockercfg -n $DEV_PROJECT

oc create secret docker-registry quayio-dockercfg \
  --docker-server=${QUAYIO_REGISTRY} \
  --docker-username=${QUAYIO_USER} \
  --docker-password=${QUAYIO_PASSWORD} \
  --docker-email=${QUAYIO_EMAIL} \
  -n $CICD_PROJECT

oc create secret docker-registry quayio-dockercfg \
  --docker-server=${QUAYIO_REGISTRY} \
  --docker-username=${QUAYIO_USER} \
  --docker-password=${QUAYIO_PASSWORD} \
  --docker-email=${QUAYIO_EMAIL} \
  -n $PROD_PROJECT  

oc create secret docker-registry quayio-dockercfg \
  --docker-server=${QUAYIO_REGISTRY} \
  --docker-username=${QUAYIO_USER} \
  --docker-password=${QUAYIO_PASSWORD} \
  --docker-email=${QUAYIO_EMAIL} \
  -n $DEV_PROJECT 

oc secrets link builder quayio-dockercfg -n $CICD_PROJECT
oc secrets link jenkins quayio-dockercfg -n $CICD_PROJECT
oc secrets link default quayio-dockercfg -n $CICD_PROJECT

oc secrets link default quayio-dockercfg -n $PROD_PROJECT