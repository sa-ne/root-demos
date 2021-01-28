#!/usr/bin/env bash

export IP=ocp.datr.eu
export PROJECT=hygieia

oc login https://${IP}:8443

oc delete project $PROJECT
oc adm new-project $PROJECT --node-selector='capability=apps' 2> /dev/null
while [ $? \> 0 ]; do
    sleep 1
    printf "."
oc adm new-project $PROJECT --node-selector='capability=apps' 2> /dev/null
done

oc label namespace $PROJECT istio-injection=disabled

oc project $PROJECT

oc create -f secret.yaml
