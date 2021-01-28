#!/usr/bin/env bash

oc project amazin-prod

oc delete policy.authentication.istio.io --all -n amazin-prod
oc delete gateway --all -n amazin-prod
oc delete virtualservice --all -n amazin-prod
oc delete destinationrule --all -n amazin-prod


sleep 10

oc apply -f amazin-prd-gateway.yaml -n amazin-prod
oc apply -f amazin-prd-destrules.yaml -n amazin-prod
oc apply -f amazin-prd-vs-all-v1.yaml -n amazin-prod
oc apply -f auth-policy.yaml -n amazin-prod


