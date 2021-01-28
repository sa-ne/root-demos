#!/bin/bash


oc create secret docker-registry quayio-dockercfg \
  --docker-server=quay.io \
  --docker-username=${QUAYIO_USER} \
  --docker-password=${QUAYIO_PASSWORD} \
  --docker-email=jusdavis@redhat.com \
  -n cicd


oc secrets link builder quayio-dockercfg  -n cicd 