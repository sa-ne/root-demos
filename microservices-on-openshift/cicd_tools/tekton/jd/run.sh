#!/usr/bin/env bash

. ../../env.sh

PROJECT=tekton-test
#
oc login https://${IP}:8443 -u $USER

oc delete project $PROJECT
oc new-project $PROJECT 2> /dev/null
while [ $? \> 0 ]; do
    sleep 1
    printf "."
oc new-project $PROJECT 2> /dev/null
done

oc project tekton-test
#
oc adm policy add-scc-to-user anyuid -z default -n $PROJECT
oc adm policy add-scc-to-user privileged -z default -n $PROJECT
#
##oc apply -f git_checkout_taskrun.yaml
##oc apply -f vol_test.yaml
#
oc process -f ../java_builder_image/build.yml | oc apply -f -

oc start-build "java-builder" --follow

oc delete Tasks,TaskRuns,Pipelines,PipelineRuns,PipelineResources --all
oc delete clusterrolebindings default-cluster-admin

#oc apply -f java_build_taskrun.yaml
#oc apply -f demo_pipeline.yaml
#oc apply -f java_pipeline.yaml

oc process -f java-pipeline-template.yaml | oc apply -f -
#oc process -f java-pipeline-template.yaml -o=yaml > out.yaml
#oc apply -f out.yaml