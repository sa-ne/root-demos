#!/usr/bin/env bash

. ./env.sh

export APP=mongodb

oc project $PROJECT

oc delete all -l app=${APP}
oc delete secret ${APP}

oc new-app -f mongo-statefulset-template.yml \
    -p REPLICAS=1
    -p VOLUME_CAPACITY=1Gi \
    -p MEMORY_LIMIT=1Gi \
    -p MONGODB_USER=motability \
    -p MONGODB_PASSWORD=motability \
    -p MONGODB_DATABASE=motability \
    -p MONGODB_ADMIN_PASSWORD=changeme \
    -p MONGODB_REPLICA_NAME=rs0 \
    -p MONGODB_KEYFILE_VALUE=ftwegtyeryn57n7n567564v

