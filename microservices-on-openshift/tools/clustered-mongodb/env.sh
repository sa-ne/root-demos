#!/usr/bin/env bash

export IP=openshift.nonprod.theosmo.com
export USER=justind
export PROJECT=cd-improvements

oc login https://${IP}:8443 -u $USER


