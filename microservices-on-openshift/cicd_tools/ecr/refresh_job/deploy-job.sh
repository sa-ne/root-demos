#!/usr/bin/env bash

. ./env.sh

SA_USER=ecr-creds-agent

oc login https://${IP}:8443 -u ${USER}

oc project $PROJECT

oc delete sa ${SA_USER}
oc delete Cronjob aws-registry-credential-cron

oc create sa ${SA_USER}
oc adm policy add-scc-to-user nonroot -z ${SA_USER}
oc adm policy add-role-to-user admin -z ${SA_USER}

oc adm policy who-can create secrets

oc create -f aws.cron.yml