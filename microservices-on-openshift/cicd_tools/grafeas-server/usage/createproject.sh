#!/usr/bin/env bash

curl -v -X POST http://grafeas-cicd.apps.ocp.datr.eu/v1alpha1/projects \
    -H "Content-Type: application/json" \
    --data '{"name":"projects/provider_example"}'




