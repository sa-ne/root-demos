## 3scale Notes.

### 20 April 2020.

Using the Operaor v0.51 for 3Scale 2.8

£scale use RWMany for some of it storage. I'm using NFS as it's all I have.

```
apiVersion: apps.3scale.net/v1alpha1
kind: APIManager
metadata:
  annotations:
    apps.3scale.net/apimanager-threescale-version: '2.8'
    apps.3scale.net/threescale-operator-version: 0.5.0
  name: apimanager
  namespace: 3scale
spec:
  imageStreamTagImportInsecure: false
  resourceRequirementsEnabled: false
  system:
    appSpec:
      replicas: 1
    sidekiqSpec:
      replicas: 1
  appLabel: 3scale-api-management
  zync:
    appSpec:
      replicas: 1
    queSpec:
      replicas: 1
  backend:
    cronSpec:
      replicas: 1
    listenerSpec:
      replicas: 1
    workerSpec:
      replicas: 1
  tenantName: 3scale
  apicast:
    managementAPI: status
    openSSLVerify: false
    productionSpec:
      replicas: 1
    registryURL: 'http://apicast-staging:8090/policies'
    responseCodes: true
    stagingSpec:
      replicas: 1
  wildcardDomain: apps.ocp4.datr.eu

  ```
Real problems getting the default MySQL to come up. In the end I need to switch my NFS to faster storage on NVME, and things began to work.


You can install the database up fron as long as the config provides

```
kind: Secret
apiVersion: v1
metadata:
  name: system-database
  namespace: 3scale
data:
  DB_PASSWORD: ZndxaHNpRUc=
  DB_USER: bXlzcWw=
  URL: bXlzcWwyOi8vcm9vdDpSdVEwREVHeUBzeXN0ZW0tbXlzcWwvc3lzdGVt
type: Opaque

URL must have format :

mysql2://root:RuQ0DEGy@system-mysql/system

only thing that should be altered is the password itself

```


### Admin Credentials

oc get secret system-seed -o json | jq -r .data.ADMIN_USER | base64 -d
admin
oc get secret system-seed -o json | jq -r .data.ADMIN_PASSWORD | base64 -d

First login is to admin portal

https://3scale-admin.apps.ocp4.datr.eu/p/login


https://api-3scale-apicast-staging.apps.ocp4.datr.eu/user_key=03226d783b62ca6c5b7f5c98213907b1



Create a Tenant

see folder test_tenant : this currently (April 2020) only partiallworks. Tenant get created but APIs do not get created.


3scale Toolbox

## On fedora

yum install ruby-devel gcc make rpm-build rubygems zlib libxml2 zlib-devel

gem install 3scale_toolbox
