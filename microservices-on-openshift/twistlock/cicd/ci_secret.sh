#!/usr/bin/env bash


. ../env.sh

oc login https://${OCP}:8443 -u $USER

oc project scantest

echo -n 'jenkins' > username.txt
echo -n 'jenkins' > password.txt

oc create secret generic twistlock-scan \
  --from-file=username=username.txt \
  --from-file=password=password.txt

oc secrets link builder twistlock-scan