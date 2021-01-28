#!/usr/bin/env bash

oc project amazin-prod

oc delete policy --all -n amazin-prod
oc delete rbacconfig --all -n amazin-prod
oc delete meshpolicy --all -n amazin-prod
oc delete servicerole --all -n amazin-prod
oc delete servicerolebinding --all -n amazin-prod
oc delete gateway --all -n amazin-prod
oc delete virtualservice --all -n amazin-prod
oc delete destinationrule --all -n amazin-prod

# oc delete policy default
# oc delete virtualservice amazin-prd
# oc delete virtualservice inventory
# oc delete virtualservice user
# oc delete virtualservice basket
# oc delete virtualservice api-gateway
# oc delete destinationrule inventory
# oc delete destinationrule user
# oc delete destinationrule basket
# oc delete destinationrule api-gateway
# oc delete gateway amazin-gateway-prod

oc apply -f namespace-policy.yaml -n amazin-prod
oc apply -f amazin-prd-gateway.yaml -n amazin-prod
oc apply -f amazin-prd-destrules.yaml -n amazin-prod
oc apply -f amazin-prd-vs-all-v1.yaml -n amazin-prod


