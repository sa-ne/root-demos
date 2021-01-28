#!/bin/bash

# ServiceMesh on OCP4 does'nt install a tls route, nor do the operator docs cover how the operator might do that for you.

# https://istio.io/docs/tasks/traffic-management/ingress/secure-ingress-mount/

oc create -n istio-system secret tls istio-ingressgateway-certs --cert=/Users/justin/.acme.sh/datr.eu/fullchain.cer --key=/Users/justin/.acme.sh/datr.eu/datr.eu.key

oc apply -f ingress-tls-route.yaml