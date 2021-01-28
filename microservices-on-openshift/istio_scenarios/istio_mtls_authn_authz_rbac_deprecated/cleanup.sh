#!/usr/bin/env bash

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

