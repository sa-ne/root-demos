#!/usr/bin/env bash


. ../env.sh

oc login https://${IP} -u $USER

oc delete secret nexus-dockercfg

oc create secret docker-registry nexus-dockercfg \
  --docker-server=${REGISTRY} \
  --docker-username=${NEXUS_USER} \
  --docker-password=${NEXUS_PASSWORD} \
  --docker-email=docker@email.com \
  -n $DEV_PROJECT

oc secrets link deployer nexus-dockercfg -n $DEV_PROJECT
oc secrets link builder nexus-dockercfg -n $DEV_PROJECT
