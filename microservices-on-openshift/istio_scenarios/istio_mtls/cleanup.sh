#!/usr/bin/env bash

oc project amazin-prod

oc delete virtualservice amazin-prd
oc delete virtualservice inventory
oc delete virtualservice user
oc delete virtualservice basket
oc delete virtualservice api-gateway
oc delete destinationrule inventory
oc delete destinationrule user
oc delete destinationrule basket
oc delete destinationrule api-gateway
oc delete gateway amazin-gateway-prod

