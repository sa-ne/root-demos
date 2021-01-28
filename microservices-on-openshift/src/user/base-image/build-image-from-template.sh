#!/usr/bin/env bash

export IP=ocp.datr.eu
export PROJECT=devops
export USER=justin
export ARTEFACT=jd-openjdk18-openshift
export VERSION=1.5-14.1539812388

oc login https://${IP}:8443 -u ${USER}

oc delete project $PROJECT
oc adm new-project $PROJECT --node-selector='capability=apps' 2> /dev/null
while [ $? \> 0 ]; do
    sleep 1
    printf "."
oc adm new-project $PROJECT --node-selector='capability=apps' 2> /dev/null
done

oc project openshift

oc delete configmap ${ARTEFACT}
oc delete is ${ARTEFACT}
oc delete bc ${ARTEFACT}
oc delete dc ${ARTEFACT}

oc new-app -f jdk-base-build.yaml \
    -p NAME=${ARTEFACT} \
    -p VERSION=${VERSION} \
    -p SOURCE_REPOSITORY_URL=https://github.com/justindav1s/microservices-on-openshift.git \
    -p DOCKERFILE_PATH="src/user/base-image"
