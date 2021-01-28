#!/usr/bin/env bash

curl https://grafeas-cicd.apps.ocp.datr.eu/v1beta1/projects/provider_example/occurrences \
     -X POST -H "Content-Type: application/json" -d @vulnerability.occurrence.json





