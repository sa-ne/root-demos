#!/bin/sh
#
# A script to delete namespace(s) stuck at "Terminating" state, that won't get deleted, within the OpenShift cluster. 
# You'll see an error message like this below, when you try "oc delete project <namespace>"
#
# Error from server (Conflict): Operation cannot be fulfilled on namespaces "<namespace>": The system is ensuring all content is removed from this namespace. Upon completion, this namespace will automatically be purged by the system.
#
####### </ Jeffery Bagirimvano >

#Run this on linux, sed misbehaves on a Mac

set +x 

while getopts n:u:t:h--help: option; do
  case "${option}" in
    n) NS_LIST=${OPTARG};;
    u) REST_API_URL=${OPTARG};;
    t) TOKEN=${OPTARG};;
    h|--help)
      echo "
Options:
  -n: List of namespaces to delete
  -u: The OpenShift server's REST API URL. Default: 'oc whoami --show-server'
  -t: Token to use. Default: 'oc whoami -t'
  
Examples:
  # To get help:
  force-delete-openshift-project -h
  
  # To delete 'test123' namespace:
  force-delete-openshift-project -n test123
  
  # To delete more than one namespaces, 'test123 alpha beta' namespaces:
  force-delete-openshift-project -n 'test123 alpha beta'

  # To use a different url:
  force-delete-openshift-project -n test123 -u https://console.example.com:8443
  
  # To provide a token to use:
  force-delete-openshift-project -n test123 -t _gevQ0rnvXfMJzkFy1NPh9Kf4jYOk1qhNT6wb4
  force-delete-openshift-project -n test123 -u https://console.example.com:8443 -t _gevQ0rnvXfMJzkFy1NPh9Kf4jYOk1qhNT6wb4
  "
      exit 0
      ;;
  esac
done

NAMESPACE_LIST="${NS_LIST}"
OC_REST_API_URL="${REST_API_URL:-$(oc whoami --show-server)}"

if [ ! -z "$NAMESPACE_LIST" ]; then
  echo
  for namespace in ${NAMESPACE_LIST}; do
    echo "Working on deleting ${namespace}"
    oc get ns ${namespace} -o json > delete-${namespace}-project.json
    sed -i '/\"kubernetes\"/d' delete-${namespace}-project.json
    cat delete-${namespace}-project.json
    curl -v --insecure -H "Content-Type: application/json" -H "Authorization: Bearer ${TOKEN}" -X PUT --data-binary @delete-${namespace}-project.json ${OC_REST_API_URL}/api/v1/namespaces/${namespace}/finalize
    #rm -f delete-${namespace}-project.json
  done
  echo

else
  echo
  echo "It looks like you haven't set the namespace(s)/project(s) to delete"
  echo "Check Options by using -h or --help"
  echo
fi