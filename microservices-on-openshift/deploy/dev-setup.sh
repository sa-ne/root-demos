#!/usr/bin/env bash


. ../env.sh

oc login https://${IP} -u $USER

oc delete project $DEV_PROJECT
oc new-project $DEV_PROJECT 2> /dev/null
while [ $? \> 0 ]; do
    sleep 1
    printf "."
    oc new-project $DEV_PROJECT 2> /dev/null
done

oc project $DEV_PROJECT

oc policy add-role-to-user edit system:serviceaccount:${CICD_PROJECT}:jenkins -n ${DEV_PROJECT}
oc policy add-role-to-user edit system:serviceaccount:${CICD_PROJECT}:default -n ${DEV_PROJECT}
oc policy add-role-to-user view --serviceaccount=default -n ${DEV_PROJECT}

oc create secret docker-registry nexus-dockercfg \
--docker-server=${REGISTRY} \
--docker-username=${NEXUS_USER} \
--docker-password=${NEXUS_PASSWORD} \
--docker-email=docker@gmail.com \
-n ${DEV_PROJECT}

oc secrets link builder nexus-dockercfg -n ${DEV_PROJECT}
oc secrets link deployer nexus-dockercfg --for=pull -n ${DEV_PROJECT}

oc delete project $PROD_PROJECT
oc new-project $PROD_PROJECT 2> /dev/null
while [ $? \> 0 ]; do
    sleep 1
    printf "."
    oc new-project $PROD_PROJECT 2> /dev/null
done

oc project $PROD_PROJECT

oc policy add-role-to-user edit system:serviceaccount:${CICD_PROJECT}:jenkins -n ${PROD_PROJECT}
oc policy add-role-to-user edit system:serviceaccount:${CICD_PROJECT}:default -n ${PROD_PROJECT}
oc policy add-role-to-user view --serviceaccount=default -n ${PROD_PROJECT}

#Allow all the downstream projects to pull the dev image
oc policy add-role-to-group system:image-puller system:serviceaccount:${PROD_PROJECT} -n ${DEV_PROJECT}

oc create secret docker-registry nexus-dockercfg \
--docker-server=${REGISTRY} \
--docker-username=${NEXUS_USER} \
--docker-password=${NEXUS_PASSWORD} \
--docker-email=docker@email.com \
-n ${PROD_PROJECT}

cd user && ./dev_setup.sh && cd -
cd basket && ./dev_setup.sh && cd -
cd api-gateway && ./dev_setup.sh && cd -
cd inventory && ./dev_setup.sh  && cd -
cd web && ./dev_setup.sh  && cd -
