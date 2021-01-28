#!/usr/bin/env bash

. ./env.sh

IMAGE=ocp-awscli
VERSION=1
REGISTRY_HOST=docker-registry-default.apps.ocp.datr.eu:443

oc login https://${IP}:8443 -u $USER

oc delete project $PROJECT
oc new-project $PROJECT 2> /dev/null
while [ $? \> 0 ]; do
    sleep 1
    printf "."
oc new-project $PROJECT 2> /dev/null
done


docker build -t $IMAGE .

TAG=$REGISTRY_HOST/$PROJECT/$IMAGE:$VERSION

docker tag $IMAGE $TAG

TOKEN=`oc whoami -t`

docker login -p $TOKEN -u justin $REGISTRY_HOST

sleep 5

docker push $TAG

