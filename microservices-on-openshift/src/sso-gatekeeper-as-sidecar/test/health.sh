#!/bin/bash

URL=http://127.0.0.1:8081/api/products/all
URL=http://127.0.0.1:3000/api/products/all
URL=http://sso-gatekeeper-api-gateway-amazin-dev.apps.ocp.datr.eu/health

curl -v -X GET \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    $URL

