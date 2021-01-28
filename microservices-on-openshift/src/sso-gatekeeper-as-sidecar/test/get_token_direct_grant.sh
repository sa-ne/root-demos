#!/bin/bash

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


KEYCLOAK=https://sso-sso.apps.192.168.33.10.xip.io
REALM="amazin"
GRANT_TYPE="password"
CLIENT="webapp"
CLIENT_SECRET="0e8055c5-099d-4d87-91b4-7eb9e08ad680"
USER=$1
USER_PASSWORD=$2

#echo "Keycloak host : $KEYCLOAK"


#Get Token
POST_BODY="grant_type=${GRANT_TYPE}&client_id=${CLIENT}&client_secret=${CLIENT_SECRET}&username=${USER}&password=${USER_PASSWORD}"

#POST_BODY="grant_type=${GRANT_TYPE}&client_id=${CLIENT}&username=${USER}&password=${USER_PASSWORD}"


#echo "Keycloak host : $KEYCLOAK"
#echo POST_BODY=${POST_BODY}

RESPONSE=$(curl -qsk \
    -d ${POST_BODY} \
    -H "Content-Type: application/x-www-form-urlencoded" \
    ${KEYCLOAK}/auth/realms/${REALM}/protocol/openid-connect/token)

#echo "RESPONSE"=${RESPONSE}
ACCESS_TOKEN=$(echo ${RESPONSE} | jq -r .access_token)
#PART2_BASE64=$(echo ${ACCESS_TOKEN} | cut -d"." -f2)
#PART2_BASE64=$(padBase64 ${PART2_BASE64})
#echo ${PART2_BASE64} | base64 -D | jq .

echo $ACCESS_TOKEN



