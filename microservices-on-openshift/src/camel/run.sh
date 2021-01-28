#!/usr/bin/env bash

mvn clean package
java  -jar target/camel-test-1.0.jar
