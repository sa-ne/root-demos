#!/bin/bash

. ./lic.sh

export OCP=ocp.datr.eu
export USER=justin
export TWISTLOCK_PUBLIC_REGISTRY="registry.twistlock.com"
export TWISTLOCK_VERSION="18_11_128"
export TWISTLOCK_RELEASE_URL="https://cdn.twistlock.com/releases/09fa81fd/twistlock_18_11_128.tar.gz"
export TWISTLOCK_NAMESPACE="twistlock"
export ACCESS_TOKEN=${KEY}
export TWISTLOCK_LICENSE=${LIC}
export TWISTLOCK_EXTERNAL_ROUTE="console-twistlock.apps.ocp.datr.eu"
export TWISTLOCK_CONSOLE_USER=${TW_ADMIN}
export TWISTLOCK_CONSOLE_PASSWORD=${TW_PASSWD}
export IMAGE_REGISTRY_EXTERNAL=$(oc get route docker-registry -n default | awk '{print $2}' | tail -n +2)
export IMAGE_REGISTRY_INTERNAL="docker-registry.default.svc:5000"
export IMAGE_REGISTRY_ADDRESS="$IMAGE_REGISTRY_INTERNAL/twistlock/private:console_$TWISTLOCK_VERSION"
