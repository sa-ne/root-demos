#!/bin/bash

NEXUS=$(oc get pod | grep nexus | awk '{ print $1 }') 

PASS=$(oc rsh $NEXUS cat /nexus-data/admin.password)

echo PASSWORD = $PASS
