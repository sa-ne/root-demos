#!/bin/bash

. ../../env.sh

PROJECT=3scale 

oc login https://${IP} -u $USER


oc delete ClusterServiceVersion 3scale-operator.v0.5.1 --ignore-not-found
oc delete subscriptions 3scale-operator --ignore-not-found

oc delete project $PROJECT
oc new-project $PROJECT 2> /dev/null
while [ $? \> 0 ]; do
    sleep 1
    printf "."
oc new-project $PROJECT 2> /dev/null
done

oc create secret docker-registry threescale-registry-auth \
  --docker-server=registry.redhat.io \
  --docker-username=${RHN_USERNAME} \
  --docker-password=${RHN_PASSWORD}

APP_NAME=postgresql
DATABASE_USER=3scale
DATABASE_PASSWORD=3scale
DATABASE_NAME=3scale

oc delete all -l app=${APP_NAME}
oc delete pvc ${APP_NAME}-pvc

oc new-app -f postgresql-persistent-template.yaml \
    -p APPLICATION_NAME=${APP_NAME} \
    -p POSTGRESQL_USER=${DATABASE_USER} \
    -p POSTGRESQL_PASSWORD=${DATABASE_PASSWORD} \
    -p POSTGRESQL_DATABASE=${DATABASE_NAME} 

oc apply -f db-secret.yaml

oc apply -f operatorgroup.yaml
oc apply -f subscription.yaml