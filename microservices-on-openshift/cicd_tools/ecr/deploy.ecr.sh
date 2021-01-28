#!/usr/bin/env bash

set -x

IMAGE=grafeas
REGISTRY_HOST=005459661421.dkr.ecr.eu-west-1.amazonaws.com

docker build -t $IMAGE .

TAG=005459661421.dkr.ecr.eu-west-1.amazonaws.com/dev/$IMAGE:v1
TAGLATEST=005459661421.dkr.ecr.eu-west-1.amazonaws.com/dev/$IMAGE:latest

docker tag $IMAGE $TAG
docker tag $IMAGE $TAGLATEST

eval $(aws ecr get-login --no-include-email --profile ecr_dev --region eu-west-1)

docker push $TAG
docker push $TAGLATEST
