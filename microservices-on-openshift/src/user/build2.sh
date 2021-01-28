#!/usr/bin/env bash

export IP=ocp.datr.eu
export PROJECT=cd-improvement
export ARTEFACT=user

oc login https://${IP}:8443

oc  project $PROJECT

oc delete secret bitbucket
oc delete configmap ${ARTEFACT}
oc delete is ${ARTEFACT}
oc delete bc ${ARTEFACT}
oc delete dc ${ARTEFACT}

mvn package

oc new-app -f ocp/build-config.yaml \
    -p RESOURCE_NAME=user \
    -p APP_LABEL=user \
    -p DOCKER_REGISTRY=docker-registry.default.svc:5000 \
    -p IMAGE_VERSION=v1 \
    -p NAMESPACE=$PROJECT

oc start-build user --from-dir=. --follow
