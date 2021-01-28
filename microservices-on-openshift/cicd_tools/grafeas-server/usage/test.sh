#!/usr/bin/env bash


curl -v http://grafeas-cicd.apps.ocp.datr.eu/v1beta1/projects/project_gWhTU/notes \
    -X POST \
    -H "Content-Type: application/json" \
    --data '{"name":"projects/project_gWhTU/notes/build_LMxNA","short_description":"This is a build for project project_gWhTU","kind":"BUILD","build":{"builder_version":"1.0"}}'
