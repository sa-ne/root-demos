#!/bin/bash

URL=http://sso-gatekeeper-inventory-amazin-dev.apps.192.168.33.10.xip.io/products/all

function padBase64  {
    STR=$1
    MOD=$((${#STR}%4))
    if [ $MOD -eq 1 ]; then
       STR="${STR}="
    elif [ $MOD -gt 1 ]; then
       STR="${STR}=="
    fi
    echo ${STR}
}


curl -v -X GET \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    $URL