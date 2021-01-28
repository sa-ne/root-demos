#!/usr/bin/env bash
 . ../../env.sh

oc project $CICD_PROJECT

oc delete svc,route nexus3-docker

oc apply -f registry-route.yaml
