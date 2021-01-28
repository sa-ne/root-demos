#!/bin/bash

. ./env.sh

oc login https://${OCP}:8443 -u $USER

oc delete project $TWISTLOCK_NAMESPACE
oc adm new-project $TWISTLOCK_NAMESPACE --node-selector='' 2> /dev/null
while [ $? \> 0 ]; do
    sleep 1
    printf "."
oc adm new-project $TWISTLOCK_NAMESPACE --node-selector='' 2> /dev/null
done

oc project $TWISTLOCK_NAMESPACE

## Set up ImageStream pass-thru to be able to pull the container image from TwistLock's registry
oc create secret docker-registry twistlock-registry --docker-server=registry.twistlock.com --docker-username=twistlock --docker-password=${ACCESS_TOKEN} --docker-email=customer@example.com
oc import-image twistlock/defender:defender_${TWISTLOCK_VERSION} --from=registry.twistlock.com/twistlock/defender:defender_${TWISTLOCK_VERSION} --confirm
oc import-image twistlock/console:console_${TWISTLOCK_VERSION} --from=registry.twistlock.com/twistlock/console:console_${TWISTLOCK_VERSION} --confirm

oc create -f twistlock_console.yaml

# wait for Twistlock Console to be ready
n=0
console_ready=0
until [ $n -ge 60 ]; do
    if oc get pods -n $TWISTLOCK_NAMESPACE | grep twistlock-console | grep Running; then
      console_ready=1
      break
    fi
    n=$[$n+1]
    echo "Waiting for twistlock console to be ready ($n/60)"
    sleep 10
done
if [ $console_ready -eq 0 ]; then
  echo "Twistlock Console did not start in time."
  exit 1
fi

# create Twistlock Console route
cat > twistlock_external_route.yaml <<EOL
apiVersion: v1
kind: Route
metadata:
  namespace: $TWISTLOCK_NAMESPACE
  labels:
    name: console
  name: twistlock-console
spec:
  host: $TWISTLOCK_EXTERNAL_ROUTE
  port:
    targetPort: mgmt-http
  tls:
    insecureEdgeTerminationPolicy: Redirect
    termination: edge
  to:
    kind: Service
    name: twistlock-console
    weight: 100
  wildcardPolicy: None
EOL

oc apply -f twistlock_external_route.yaml

# wait for console to be ready to serve endpoints
sleep 10

# set Twistlock console user/pass
if ! curl -v -k -H 'Content-Type: application/json' -X POST \
     -d "{\"username\": \"$TWISTLOCK_CONSOLE_USER\", \"password\": \"$TWISTLOCK_CONSOLE_PASSWORD\"}" \
     https://$TWISTLOCK_EXTERNAL_ROUTE/api/v1/signup; then

    echo "Error creating Twistlock Console user $TWISTLOCK_CONSOLE_USER"
    exit 1
fi

# Set Twistlock license. Using default user/pass
if ! curl -v -k \
  -u $TWISTLOCK_CONSOLE_USER:$TWISTLOCK_CONSOLE_PASSWORD \
  -H 'Content-Type: application/json' \
  -X POST \
  -d "{\"key\": \"$TWISTLOCK_LICENSE\"}" \
  https://$TWISTLOCK_EXTERNAL_ROUTE/api/v1/settings/license; then

    echo "Error uploading Twistlock license to console"
    exit 1
fi
