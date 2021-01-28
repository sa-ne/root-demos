#!/bin/bash

# Constants
. ./env.sh

oc login https://${OCP}:8443 -u $USER
oc project $TWISTLOCK_NAMESPACE

oc delete clusterroles.rbac.authorization.k8s.io "twistlock-view"
oc delete securitycontextconstraints.security.openshift.io "twistlock-scc"
oc delete secrets "twistlock-secrets"
oc delete serviceaccounts "twistlock-service"
oc delete daemonsets.extensions "twistlock-defender-ds"

#if [[ ! -f ./twistcli || $(./twistcli --version) != *"18.11.128"* ]]; then curl --progress-bar -L -k --header "authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiYWRtaW4iLCJyb2xlIjoiYWRtaW4iLCJncm91cHMiOm51bGwsInByb2plY3RzIjpudWxsLCJzZXNzaW9uVGltZW91dFNlYyI6ODY0MDAsImV4cCI6MTU1MDQ4NTgzMywiaXNzIjoidHdpc3Rsb2NrIn0.bb4Ql4IBor5HZ_tyzmHDMm4bHWwBqucNAPvK9nvFcWA" https://console-twistlock.apps.ocp.datr.eu/api/v1/util/twistcli > twistcli; chmod +x twistcli; fi;

#./twistcli defender export openshift \
#   --address https://$TWISTLOCK_EXTERNAL_ROUTE \
#   --cluster-address $(oc get service twistlock-console -n $TWISTLOCK_NAMESPACE | awk '{print $2}' | tail -n +2) \
#   --namespace $TWISTLOCK_NAMESPACE \
#   --image-name registry.twistlock.com/twistlock/defender:defender_$TWISTLOCK_VERSION \
#   --user $TWISTLOCK_CONSOLE_USER \
#   --password $TWISTLOCK_CONSOLE_PASSWORD \
# echo "$daemonset_file"

oc create -f daemonset.yaml