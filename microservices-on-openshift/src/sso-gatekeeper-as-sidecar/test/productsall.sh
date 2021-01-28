#!/bin/bash

URL=http://127.0.0.1:8081/api/products/all
URL=http://127.0.0.1:3000/api/products/all
URL=https://sso-gatekeeper-amazin-dev.apps.ocp.datr.eu/api/products/all
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

ACCESS_TOKEN=$(./get_token_direct_grant.sh justin 12jnd34)

echo $ACCESS_TOKEN
PART1_BASE64=$(echo ${ACCESS_TOKEN} | cut -d"." -f1)
PART1_BASE64=$(padBase64 ${PART1_BASE64})
echo ${PART1_BASE64} | base64 -D | jq .
PART2_BASE64=$(echo ${ACCESS_TOKEN} | cut -d"." -f2)
PART2_BASE64=$(padBase64 ${PART2_BASE64})
echo ${PART2_BASE64} | base64 -D | jq .


curl -X GET \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer ${ACCESS_TOKEN}" \
    $URL

