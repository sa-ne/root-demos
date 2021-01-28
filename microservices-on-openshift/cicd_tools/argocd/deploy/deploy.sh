#!/bin/bash

PROJECT=argocd

oc delete -f argocd-admins-group.yaml
oc delete -f project1-groups.yaml
oc delete -f project2-groups.yaml

oc delete project $PROJECT
oc new-project $PROJECT 2> /dev/null
while [ $? \> 0 ]; do
    sleep 1
    printf "."
oc new-project $PROJECT 2> /dev/null
done

oc create secret generic github-secret --from-file=ssh-privatekey=${HOME}/.ssh/id_rsa

oc apply -f operatorgroup.yaml
oc apply -f subscription.yaml

oc apply -f argocd_instance.yaml
oc apply -f argocd-admins-group.yaml
oc apply -f project1-groups.yaml
oc apply -f project2-groups.yaml
oc apply -f argocd-project1.yaml
oc apply -f argocd-project2.yaml
oc apply -f project1-app.yaml
oc apply -f project2-app.yaml