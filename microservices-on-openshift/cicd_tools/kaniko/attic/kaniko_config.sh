#!/usr/bin/env bash

. ../env.sh

oc login https://${IP}:8443 -u $USER

APP_NAME="kaniko"

oc delete dc,pvc -l app=${APP_NAME}

BUILDER_SECRET=$(oc get secrets | grep builder-dockercfg | awk '{print $1}')
echo BUILDER_SECRET : ${BUILDER_SECRET}

oc new-app  -f kaniko-config-template.yaml \
    -p APPLICATION_NAME=${APP_NAME} \
    -p BUILDER_SECRET=${BUILDER_SECRET}

oc rollout status dc/${APP_NAME} -w

export POD=$(oc get pod -l app=${APP_NAME} | grep -m1 ${APP_NAME} | awk '{print $1}')

echo POD = $POD

TOKEN=$(oc exec $POD -c kaniko-loader cat /var/run/secrets/kubernetes.io/serviceaccount/token)

cat <<EOF > config.json
{
  "auths": {
    "docker-registry.default.svc.cluster.local:5000": {
      "username": "serviceaccount",
      "password": "${TOKEN}",
      "email": "serviceaccount@example.org",
    }
  }
}
EOF

oc cp example_app/Dockerfile $POD:/tmp/app/
oc cp example_app/hello-example.js $POD:/tmp/app/