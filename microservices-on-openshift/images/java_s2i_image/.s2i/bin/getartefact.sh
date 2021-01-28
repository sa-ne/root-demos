#!/usr/bin/env bash

NEXUS_SERVICE=$1
NEXUS_PORT=$2
GRP=$3
ARTEFACT=$4
VERSION=$5
PACKAGING=$6

mvn org.apache.maven.plugins:maven-dependency-plugin:2.1:get \
    -DrepoUrl=$NEXUS_SERVICE:$NEXUS_PORT/repository/maven-public/ \
    -Dartifact=$GRP:$ARTEFACT:$VERSION \
    -Dpackaging=$PACKAGING

GRPDIR=$(echo $GRP | sed 's/\./\//')

cp ~/.m2/repository/$GRPDIR/$ARTEFACT/$VERSION/product.backend-$VERSION.war .
