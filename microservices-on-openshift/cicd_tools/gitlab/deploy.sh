#!/usr/bin/env bash

. ../env.sh

oc login https://${IP}:8443 -u justin

APP=gitlab-ce
PROJECT=gitlab

oc login https://${IP}:8443 -u $USER

oc delete project $PROJECT
oc adm new-project $PROJECT --node-selector='capability=apps' 2> /dev/null
while [ $? \> 0 ]; do
    sleep 1
    printf "."
oc adm new-project $PROJECT --node-selector='capability=apps' 2> /dev/null
done

oc project $PROJECT

oc delete all -l app=${APP}
oc delete serviceaccount ${APP}-user

oc create serviceaccount ${APP}-user
oc adm policy add-scc-to-user anyuid -z ${APP}-user

oc new-app -f gitlab-template.yaml \
    -p APPLICATION_NAME=${APP} \
    -p APPLICATION_HOSTNAME=${APP}-${PROJECT}.apps.ocp.datr.eu \
    -p GITLAB_ROOT_PASSWORD=ZaqXsw123 \
    -p POSTGRESQL_USER=gitlab \
    -p POSTGRESQL_PASSWORD=ZaqXsw123 \
    -p POSTGRESQL_ADMIN_PASSWORD=ZaqXsw123 \
    -p POSTGRESQL_DATABASE=gitlab \
    -p UNICORN_WORKERS=2 \
    -p ETC_VOL_SIZE=100Mi \
    -p GITLAB_DATA_VOL_SIZE=10Gi \
    -p POSTGRESQL_VOL_SIZE=10Gi \
    -p REDIS_VOL_SIZE=10Gi
