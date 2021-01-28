#!/bin/bash

oc apply -f - <<EOF
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: serverless-operator
  namespace: openshift-operators 
spec:
  channel: techpreview
  name: serverless-operator 
  source: redhat-operators 
  sourceNamespace: openshift-marketplace
EOF