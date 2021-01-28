#Deployment scripts

A selection of resources to set up : 
   * Jenkins Pipelines
   * OCP constructs
   * Istio components
   
##Making a template from what's there :

oc export all -l app=inventory --as-template="invenory-prd-template" > invenory-prd-template.yml  
oc export pod -l app=web --as-template="web-pod-template" > web-pod-template.yml  

##Istio : Useful commands

istioctl authn tls-check | grep amazin-prod


###Get Spiffe

oc exec $(oc get pod -l app=api-gateway -o jsonpath={.items..metadata.name}) -c istio-proxy \
    -- cat /etc/certs/cert-chain.pem | openssl x509 -text -noout  | grep 'Subject Alternative Name' -A 1 
    
##Get certs

oc exec $(oc get pod -l app=api-gateway -o jsonpath={.items..metadata.name}) -c istio-proxy -- ls /etc/certs

##Get Cert validity

oc exec $(oc get pod -l app=api-gateway -o jsonpath={.items..metadata.name}) -c istio-proxy \
    -- cat /etc/certs/cert-chain.pem | openssl x509 -text -noout  | grep Validity -A 2
    
    
oc exec $(oc get pod -l app=api-gateway -o jsonpath={.items..metadata.name}) -c istio-proxy -- cat /etc/certs/cert-chain.pem | openssl x509 -text -noout

istioctl authn tls-check api-gateway-v1-2-7jtlf inventory-prd.amazin-prod.svc.cluster.local