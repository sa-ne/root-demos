#!/usr/bin/env bash

export PROJECT=hygieia
export APP=test-app

oc login https://ocp.datr.eu:8443 -u justin

oc project $PROJECT

oc delete all -l app=${APP}
oc delete is,bc ${APP}
oc delete secret stibo-pricing-dev

mvn clean package -DskipTests

oc create secret generic stibo-pricing-dev \
    --from-file=private_key.pem=private_key.pem \
    --type=Opaque

oc new-app -f app-template.yaml \
    -p RESOURCE_NAME=${APP} \
    -p APP_LABEL=${PROJECT}-${APP} \
    -p DOCKER_REGISTRY=docker-registry.default.svc:5000 \
    -p IMAGE_VERSION=v1 \
    -p NAMESPACE=$PROJECT

oc start-build ${APP}  --from-dir=. --follow
