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


KEYCLOAK=https://sso-sso.apps.ocp4.datr.eu
REALM="mex"
GRANT_TYPE="authorization_code"
CLIENT="mobile-app"
CLIENT_SECRET="7627c30b-a1a2-4138-b569-1d1eda2845d9"
REDIRECT="http%3A%2F%2Fsso-relay-amazin-dev.apps.ocp4.datr.eu%2Fapi%2Fhandle-oauth"
USER="justin"
USER_PASSWORD="12jnd34"

echo "Keycloak host : $KEYCLOAK"

#Get Code
GET_BODY="scope=openid&response_type=code&client_id=${CLIENT}&redirect_uri=${REDIRECT}"

RESPONSE=$(curl -L -vk -D headers.txt \
    -u ${USER}:${USER_PASSWORD} \
    -X GET \
    ${KEYCLOAK}/auth/realms/${REALM}/protocol/openid-connect/auth?${GET_BODY})

echo RESPONSE=$RESPONSE
#LOC=$(grep Location headers.txt)
##rm -rf headers.txt
#CODE=`echo ${LOC} | awk -F'[=&]' '{print $4}' | tr -cd "[:print:]\n"`
#
#echo "CODE"=${CODE}
#echo ${#CODE}
#
##Get Token
#POST_BODY="grant_type=${GRANT_TYPE}&redirect_uri=${REDIRECT}&client_id=${CLIENT}&client_secret=${CLIENT_SECRET}&code="
#POST_BODY=${POST_BODY}${CODE}
#echo POST_BODY=${POST_BODY}
#
#RESPONSE=$(curl -vk \
#    -d ${POST_BODY} \
#    -H "Content-Type: application/x-www-form-urlencoded" \
#    ${KEYCLOAK}/auth/realms/${REALM}/protocol/openid-connect/token)
#
#echo "RESPONSE"=${RESPONSE}
#ACCESS_TOKEN=$(echo ${RESPONSE} | jq -r .access_token)
#PART2_BASE64=$(echo ${ACCESS_TOKEN} | cut -d"." -f2)
#PART2_BASE64=$(padBase64 ${PART2_BASE64})
#echo "ACCESS TOKEN"
#echo ${PART2_BASE64} | base64 -D | jq .
#
#echo
#ACCESS_TOKEN=$(echo ${RESPONSE} | jq -r .refresh_token)
#PART2_BASE64=$(echo ${ACCESS_TOKEN} | cut -d"." -f2)
#PART2_BASE64=$(padBase64 ${PART2_BASE64})
#echo "REFRESH TOKEN"
#echo ${PART2_BASE64} | base64 -D | jq .
#
#echo
#ACCESS_TOKEN=$(echo ${RESPONSE} | jq -r .id_token)
#PART2_BASE64=$(echo ${ACCESS_TOKEN} | cut -d"." -f2)
#PART2_BASE64=$(padBase64 ${PART2_BASE64})
#echo "ID TOKEN"
#echo ${PART2_BASE64} | base64 -D | jq .