#!/usr/bin/env bash

APP_NAME=postgresql
DATABASE_USER=sonar
DATABASE_PASSWORD=sonar
DATABASE_NAME=sonar

oc project cicd

oc delete all -l app=${APP_NAME}
oc delete pvc ${APP_NAME}-pvc

oc new-app -f postgresql-persistent-template.yaml \
    -p APPLICATION_NAME=${APP_NAME} \
    -p POSTGRESQL_USER=${DATABASE_USER} \
    -p POSTGRESQL_PASSWORD=${DATABASE_PASSWORD} \
    -p POSTGRESQL_DATABASE=${DATABASE_NAME}


