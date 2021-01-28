## Deployment commands

https://github.com/kubernetes-sigs/kustomize/blob/master/docs/README.md

### Projects/Namespaces

   * kustomize build projects
   * kustomize build projects/amazin-dev

   * kustomize build projects | oc apply -f -
   * kustomize build projects/amazin-dev | oc apply -f -


### Services

   * kustomize build services/overlays/dev | oc apply -f -
   * kustomize build services/overlays/dev/inventory | oc apply -f -
