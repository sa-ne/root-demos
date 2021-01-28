#!/bin/bash


SERVICE_NAME=product
GROUPID=org.jnd.microservices.quarkus

mvn io.quarkus:quarkus-maven-plugin:1.2.1.Final:create \
    -DprojectGroupId=${GROUPID} \
    -DprojectArtifactId=${SERVICE_NAME} \
    -DclassName="${GROUPID}.${SERVICE_NAME}" \
    -Dpath="/${SERVICE_NAME}"