#!/usr/bin/env bash

curl http://grafeas-cicd.apps.ocp.datr.eu/v1alpha1/projects/provider_example/notes?note_id=testNote \
    -X POST -H "Content-Type: application/json" -d @vulnerability.note.json





