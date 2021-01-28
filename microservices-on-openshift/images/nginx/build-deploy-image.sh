#!/usr/bin/env bash

. ../../env.sh

# docker login registry.redhat.io

docker pull registry.redhat.io/ubi8/ubi

IMAGE=jd-nginx:latest

docker build -t $IMAGE .

REGISTRY_HOST=nexus3-docker-cicd.apps.ocp4.datr.eu:443
USER=admin
docker tag $IMAGE $REGISTRY_HOST/$IMAGE
echo "Pushing to : $REGISTRY_HOST as $USER"
docker login -u $USER $REGISTRY_HOST
docker push $REGISTRY_HOST/$IMAGE

REGISTRY_HOST=quay.io/justindav1s
USER=justindav1s
docker tag $IMAGE $REGISTRY_HOST/$IMAGE
echo "Pushing to : $REGISTRY_HOST as $USER"
docker login -u $USER $REGISTRY_HOST
docker push $REGISTRY_HOST/$IMAGE
