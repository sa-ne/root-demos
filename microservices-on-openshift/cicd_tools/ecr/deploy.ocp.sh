#!/usr/bin/env bash

. ../env.sh

set -x

oc login https://${IP}:8443 -u $USER

IMAGE=grafeas-server
REGISTRY_HOST=docker-registry-default.apps.ocp.datr.eu:443

docker build -t $IMAGE .

TAG=$REGISTRY_HOST/openshift/$IMAGE:v1
TAGLATEST=$REGISTRY_HOST/openshift/$IMAGE:latest

docker tag $IMAGE $TAG

TOKEN=`oc whoami -t`

docker login -p $TOKEN -u justin $REGISTRY_HOST

sleep 5

docker push $TAG
docker push $TAGLATEST
