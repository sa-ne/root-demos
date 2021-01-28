#!/usr/bin/env bash

. ../env.sh

oc login https://${IP} -u $USER

oc delete project $PROD_PROJECT
oc new-project $PROD_PROJECT 2> /dev/null
while [ $? \> 0 ]; do
    sleep 1
    printf "."
    oc new-project $PROD_PROJECT 2> /dev/null
done


oc policy add-role-to-user edit system:serviceaccount:${CICD_PROJECT}:jenkins -n ${PROD_PROJECT}
oc policy add-role-to-user edit system:serviceaccount:${CICD_PROJECT}:default -n ${PROD_PROJECT}
oc policy add-role-to-user view --serviceaccount=default -n ${PROD_PROJECT}

#Allow all the downstream projects to pull the dev image
oc policy add-role-to-group system:image-puller system:serviceaccounts:${PROD_PROJECT} -n ${DEV_PROJECT}

oc project ${PROD_PROJECT}

oc create secret docker-registry nexus-dockercfg \
  --docker-server=nexus3-docker-cicd.apps.ocp4.datr.eu \
  --docker-username=${NEXUS_USER} \
  --docker-password=${NEXUS_PASSWORD} \
  --docker-email=docker@gmail.com \
  -n ${PROD_PROJECT}


cd user && ./prd_setup.sh && cd -
cd basket && ./prd_setup.sh && cd -
cd api-gateway && ./prd_setup.sh && cd -

cd inventory && ./prd_setup_v1.sh &&  ./prd_setup_v2.sh && ./prd_setup_v3.sh && cd -