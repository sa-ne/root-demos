#!/usr/bin/env bash

#HOST=istio-ingressgateway-istio-system.apps.ocp4.datr.eu/api
HOST=tls-istio-ingressgateway-istio-system.apps.ocp4.datr.eu/api

PROTOCOL=https

for i in $(seq 1 1000)
do
    echo Iteration \# ${i}
    echo POST -H "Content-Type: application/json" -d '{"username":"justin1","password":"password"}' ${PROTOCOL}://${HOST}/login
    curl -s -X POST -H "Content-Type: application/json" -d '{"username":"justin1","password":"password"}' ${PROTOCOL}://${HOST}/login
#    echo
#    echo POST -H "Content-Type: application/json" -d '{"username":"justin1","password":"passw' ${PROTOCOL}://${HOST}/login
#    curl -s -X POST -H "Content-Type: application/json" -d '{"username":"justin1","password":"passw' ${PROTOCOL}://${HOST}/login
    echo
    echo POST -H "Content-Type: application/json" -d "{\"username\":\"justin${i}\",\"password\":\"password\"}" ${PROTOCOL}://${HOST}/login
    BASKET=$(curl -s -X POST -H "Content-Type: application/json" -d "{\"username\":\"justin${i}\",\"password\":\"password\"}" ${PROTOCOL}://${HOST}/login | jq .basketId)
    echo
    echo GET ${PROTOCOL}://${HOST}/products/all
    curl -s -X GET ${PROTOCOL}://${HOST}/products/all
    echo
    echo GET ${PROTOCOL}://${HOST}/products/7
    curl -s -X GET ${PROTOCOL}://${HOST}/products/7
#    echo
#    echo  GET ${PROTOCOL}://${HOST}/products/19
#    curl -s -X GET ${PROTOCOL}://${HOST}/products/19
#    echo
#    echo GET ${PROTOCOL}://${HOST}/prod/19
#    curl -s -X GET ${PROTOCOL}://${HOST}/prod/19
#    echo
#    echo GET ${PROTOCOL}://${HOST}/products/19
#    curl -s -X GET ${PROTOCOL}://${HOST}/products/19
#    echo
#    echo POST -H "Content-Type: application/json" -d '{"username":"justin1","password":"password"}' ${PROTOCOL}://${HOST}/user/login
#    curl -s -X POST -H "Content-Type: application/json" -d '{"username":"justin1","password":"password"}' ${PROTOCOL}://${HOST}/user/login
    echo
    echo PUT ${PROTOCOL}://${HOST}/basket/${BASKET}/add/1
    curl -s -X PUT ${PROTOCOL}://${HOST}/basket/${BASKET}/add/1
    echo
    echo PUT ${PROTOCOL}://${HOST}/basket/${BASKET}/add/7
    curl -s -X PUT ${PROTOCOL}://${HOST}/basket/${BASKET}/add/7
    echo
    echo PUT ${PROTOCOL}://${HOST}/basket/${BASKET}/add/1
    curl -s -X PUT ${PROTOCOL}://${HOST}/basket/${BASKET}/add/1
    echo
    echo PUT ${PROTOCOL}://${HOST}/basket/${BASKET}/add/9
    curl -s -X PUT ${PROTOCOL}://${HOST}/basket/${BASKET}/add/9
    echo
#    echo PUT ${PROTOCOL}://${HOST}/basket/${BASKET}/add/19
#    curl -s -X PUT ${PROTOCOL}://${HOST}/basket/${BASKET}/add/19
#    echo
#    echo PUT ${PROTOCOL}://${HOST}/basket/${BASKET}/add/anything
#    curl -s -X PUT ${PROTOCOL}://${HOST}/basket/${BASKET}/add/anything
    echo
    echo DELETE ${PROTOCOL}://${HOST}/basket/${BASKET}/remove/1
    curl -s -X DELETE ${PROTOCOL}://${HOST}/basket/${BASKET}/remove/1
    echo
#    echo DELETE ${PROTOCOL}://${HOST}/basket/${BASKET}/remove/1
#    curl -s -X DELETE ${PROTOCOL}://${HOST}/basket/${BASKET}/remove/1
#    echo
#    echo DELETE ${PROTOCOL}://${HOST}/basket/${BASKET}/remove/1
#    curl -s -X DELETE ${PROTOCOL}://${HOST}/basket/${BASKET}/remove/1
    echo
    echo GET ${PROTOCOL}://${HOST}/basket/${BASKET}/empty
    curl -s -X DELETE ${PROTOCOL}://${HOST}/basket/${BASKET}/empty
    echo
    echo PUT ${PROTOCOL}://${HOST}/basket/${BASKET}/add/9
    curl -s -X PUT ${PROTOCOL}://${HOST}/basket/${BASKET}/add/9
    echo
    echo POST -H "Content-Type: application/json" -d '{"username":"justin1","password":"password"}' ${PROTOCOL}://${HOST}/login
    curl -s -X POST -H "Content-Type: application/json" -d '{"username":"justin1","password":"password"}' ${PROTOCOL}://${HOST}/login
    echo
    echo GET ${PROTOCOL}://${HOST}/products/all
    curl -s -X GET ${PROTOCOL}://${HOST}/products/all
done







