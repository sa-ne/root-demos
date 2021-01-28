#!/bin/bash

PROJECT=jd-nginx
ID=4398196941249235572

echo Deleting $PROJECT
oc delete project $PROJECT
echo Creating $PROJECT
oc new-project $PROJECT 2> /dev/null
while [ $? \> 0 ]; do
    sleep 1
    printf "."
oc new-project $PROJECT 2> /dev/null
done

oc create secret docker-registry rh-dockercfg \
  --docker-server=registry.redhat.io \
  --docker-username=${RHDN_USERNAME} \
  --docker-password=${RHDN_PASSWORD} \
  --docker-email=${RHDN_USERNAME} \
  -n $PROJECT

oc create secret docker-registry quayio-dockercfg \
  --docker-server=quay.io \
  --docker-username=${QUAYIO_USER} \
  --docker-password=${QUAYIO_PASSWORD} \
  --docker-email=${QUAYIO_EMAIL} \
  -n $PROJECT

oc create -f  /Users/justin/rh/entitlement/11009103_ubi-ocpbuilds-secret.yaml -n $PROJECT

oc create secret generic etc-pki-entitlement \
  --from-file /Users/justin/rh/entitlement/${ID}.pem \
  --from-file /Users/justin/rh/entitlement/${ID}-key.pem \
  -n $PROJECT

oc create configmap rhsm-conf \
  --from-file /Users/justin/rh/entitlement/rhsm.conf \
  -n $PROJECT

oc create configmap rhsm-ca \
  --from-file /Users/justin/rh/entitlement/redhat-uep.pem \
  -n $PROJECT

oc secrets link builder rh-dockercfg
oc secrets link builder quayio-dockercfg
oc secrets link builder 11009103-ubi-ocpbuilds-pull-secret

oc new-build https://github.com/justindav1s/microservices-on-openshift \
    --name nginx-build \
    --push-secret="quayio-dockercfg" \
    --to="quay.io/justindav1s/jd-nginx" \
    --context-dir="images/nginx" \
    --strategy="docker" \
    --to-docker=true \
    --allow-missing-images

oc set build-secret --pull bc/nginx-build  11009103-ubi-ocpbuilds-pull-secret -n $PROJECT

oc patch buildconfig nginx-build \
  -p '{"spec":{"source":{"configMaps":[{"configMap":{"name":"rhsm-conf"},"destinationDir":"rhsm-conf"},{"configMap":{"name":"rhsm-ca"},"destinationDir":"rhsm-ca"}],"secrets":[{"destinationDir":"etc-pki-entitlement","secret":{"name":"etc-pki-entitlement"}}]}}}' \
  -n $PROJECT 