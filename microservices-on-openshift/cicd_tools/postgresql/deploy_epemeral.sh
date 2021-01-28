#!/usr/bin/env bash

APP_NAME=postgresql-96
DATABASE_USER=sonar
DATABASE_PASSWORD=sonar
DATABASE_NAME=sonar

oc project cicd

oc delete all -l app=${APP_NAME}

oc new-app registry.redhat.io/rhel8/postgresql-96 --allow-missing-images \
    -e APPLICATION_NAME=${APP_NAME} \
    -e POSTGRESQL_USER=${DATABASE_USER} \
    -e POSTGRESQL_PASSWORD=${DATABASE_PASSWORD} \
    -e POSTGRESQL_DATABASE=${DATABASE_NAME} \
    -l app=${APP_NAME}

oc create service loadbalancer ${APP_NAME} --tcp=5432:5432