#!/bin/bash

URL=https://sso-gatekeeper-amazin-dev.apps.ocp.datr.eu/api/login
#URL=https://springsec-api-gateway-amazin-dev.apps.ocp.datr.eu/api/login

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

ACCESS_TOKEN=$(./get_token_direct_grant.sh)

echo $ACCESS_TOKEN
PART2_BASE64=$(echo ${ACCESS_TOKEN} | cut -d"." -f2)
PART2_BASE64=$(padBase64 ${PART2_BASE64})
echo ${PART2_BASE64} | base64 -D | jq .


curl -v -X OPTIONS \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer ${ACCESS_TOKEN}" \
    --data '{"username":"xyz","password":"xyz"}' \
    $URL


