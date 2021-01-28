#!/usr/bin/env bash

. ../../env.sh

oc login https://${IP} -u ${USER}

oc project $CICD_PROJECT

oc delete all -l app=nexus
oc delete pvc nexus-pv

sleep 5

oc new-app -f nexus-persistent-template.yaml


