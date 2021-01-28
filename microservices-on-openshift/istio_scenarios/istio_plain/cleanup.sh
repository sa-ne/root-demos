#!/usr/bin/env bash

oc delete servicerole --all -n amazin-prod
oc delete servicerolebinding --all -n amazin-prod
oc delete policy --all -n amazin-prod
oc delete virtualservice --all -n amazin-prod
oc delete destinationrule --all -n amazin-prod
oc delete gateway --all -n amazin-prod

