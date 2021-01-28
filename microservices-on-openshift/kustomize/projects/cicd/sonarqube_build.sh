#!/usr/bin/env bash

. ../../../env.sh

oc login https://${IP} -u ${USER}

APP=sonarqube
VERSION=7.9
#REG_HOST=nexus3-docker-cicd.apps.ocp4.datr.eu
#REG_HOST=nexus3-docker-cicd.apps-crc.testing
REG_HOST=nexus-docker-cicd.apps.shared-rhpds.rhpds.openshift.opentlc.com

oc project cicd

SECRET_NAME=$(oc get secrets | grep rhpds | awk '{ print $1 }')
oc patch buildconfig sonarqube-docker-build -p "{\"spec\":{\"output\":{\"pushSecret\":{\"name\":\"$SECRET_NAME\"}}}}"

oc start-build ${APP}-docker-build  --follow

oc import-image ${APP}:${VERSION} \
  --from ${REG_HOST}/repository/docker/${APP}:${VERSION} \
  --insecure=true \
  --confirm



#then download quality profile from market place https://sonarqube-cicd.apps.ocp.datr.eu/admin/marketplace
