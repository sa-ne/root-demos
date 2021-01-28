#!/bin/bash

oc new-project amazin-serverless

kn service create inventory \
    --image quay.io/justindav1s/inventory:2 \
    --env TARGET=Knative \
    --env SPRING_PROFILES_ACTIVE=v1

kn service create api-gateway \
    --image quay.io/justindav1s/api-gateway:e00e1a3 \
    --env TARGET=Knative \
    --env SPRING_PROFILES_ACTIVE=dev