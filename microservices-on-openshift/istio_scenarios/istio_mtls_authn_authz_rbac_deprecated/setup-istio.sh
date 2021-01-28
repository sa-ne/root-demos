#!/usr/bin/env bash

oc project amazin-prod

oc delete rbacconfig --all -n istio-system
oc delete destinationrule --all -n istio-system
oc delete meshpolicy --all -n istio-system
oc delete gateway --all -n istio-system
oc delete virtualservice --all -n istio-system
oc delete servicerole --all -n amazin-prod
oc delete servicerolebinding --all -n amazin-prod
oc delete policy --all -n amazin-prod
oc delete virtualservice --all -n amazin-prod
oc delete destinationrule --all -n amazin-prod
oc delete gateway --all -n amazin-prod

oc apply -f rbac-on.yaml -n amazin-prod
oc apply -f authn-ns-policy.yaml -n amazin-prod
#oc apply -f authn-cluster-policy.yaml -n amazin-prod
#oc apply -f default-destrule-mtls.yaml -n amazin-prod
oc apply -f amazin-prd-gateway.yaml -n amazin-prod

#Authz config
oc apply -f authz-api-gateway.yaml -n amazin-prod
oc apply -f authz-user.yaml -n amazin-prod
oc apply -f authz-basket.yaml -n amazin-prod
oc apply -f authz-inventory.yaml -n amazin-prod

oc apply -f amazin-prd-destrules-mtls.yaml -n amazin-prod
oc apply -f amazin-prd-vs-all-v1.yaml -n amazin-prod

#istioctl authn tls-check | grep amazin-prod

