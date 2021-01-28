#!/usr/bin/env bash

curl -v --header "Content-Type: application/json" \
  --request POST \
  --data '{"username":"xyz","password":"xyz"}' \
  https://istio-ingressgateway-istio-system.apps.ocp.datr.eu/api/login



