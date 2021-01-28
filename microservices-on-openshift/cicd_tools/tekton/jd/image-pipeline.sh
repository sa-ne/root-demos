#!/usr/bin/env bash

. ../../env.sh

PROJECT=tekton-test

oc login https://${IP}:8443 -u $USER


oc project tekton-test

oc delete Tasks,TaskRuns,Pipelines,PipelineRuns,PipelineResources --all;
oc delete clusterrolebindings default-cluster-admin;
oc process -f java-pipeline-template.yaml | oc apply -f -