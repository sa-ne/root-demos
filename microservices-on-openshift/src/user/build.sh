#!/usr/bin/env bash

export IP=ocp.datr.eu
export PROJECT=devops
export ARTEFACT=user

oc login https://${IP}:8443

oc delete project $PROJECT
oc adm new-project $PROJECT --node-selector='capability=apps' 2> /dev/null
while [ $? \> 0 ]; do
    sleep 1
    printf "."
oc adm new-project $PROJECT --node-selector='capability=apps' 2> /dev/null
done

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
    -p DOCKER_REGISTRY=docker-registry.default.svc \
    -p IMAGE_VERSION=v1 \
    -p NAMESPACE=cd-improvements

oc start-build user --from-dir=. --follow -n $PROJECT
