#!/usr/bin/env bash

export PROJECT=jenkinsx
export APP=jenkinsx

oc login https://ocp.datr.eu:8443 -u justin

oc project $PROJECT

oc delete all -l app=${APP}
oc delete is,bc ${APP}

oc new-app -f app-template.yaml \
    -p RESOURCE_NAME=${APP} \
    -p APP_LABEL=${APP} \
    -p DOCKER_REGISTRY=docker-registry.default.svc:5000 \
    -p IMAGE_VERSION=v1 \
    -p NAMESPACE=$PROJECT

oc start-build ${APP}  --from-dir=. --follow
