#!/usr/bin/env bash

APP=webhook-manager
. ../../../env.sh

#setup Jenkins Jobs
JENKINS_USER=justin-admin
JENKINS_TOKEN=6b3cf5e2dcc7c313c91e9981ec436b03
JENKINS=jenkins-cicd.apps.ocp.datr.eu

#turn on "Prevent Cross-site scripting"

CRUMB_JSON=$(curl -v -s "https://${JENKINS_USER}:${JENKINS_TOKEN}@${JENKINS}/crumbIssuer/api/json")

echo CRUMB_JSON=$CRUMB_JSON
CRUMB=$(echo $CRUMB_JSON | jq -r .crumb)

echo CRUMB=$CRUMB

curl -v -H "Content-Type: text/xml" \
  --user ${JENKINS_USER}:${JENKINS_TOKEN} \
  -H Jenkins-Crumb:${CRUMB} \
  -X POST https://${JENKINS}/job/amazin-${APP}/doDelete

sleep 5

curl -v -H "Content-Type: text/xml" \
  --user ${JENKINS_USER}:${JENKINS_TOKEN} \
  -H Jenkins-Crumb:${CRUMB} \
  --data-binary @config.xml \
  -X POST https://${JENKINS}/createItem?name=github-${APP}

