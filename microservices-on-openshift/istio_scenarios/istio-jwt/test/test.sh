#!/bin/bash


TOKEN=$(./direct_grant.sh)

echo ${TOKEN} | base64 -D | jq .

curl -v -H "Authorization: Bearer ${TOKEN}" \
    https://tls-istio-ingressgateway-istio-system.apps.ocp4.datr.eu/api/products/all

