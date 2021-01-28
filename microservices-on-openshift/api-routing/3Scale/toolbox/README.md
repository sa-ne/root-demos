# Using 3scale Toolbox

https://developers.redhat.com/blog/2019/07/29/3scale-toolbox-deploy-an-api-from-the-cli/

## Register Tenant with toolbox

```
3scale remote add 3scale "https://cc296872c91149e83aee0ab67350beff8f744903d7387037775e02b09adcd870@3scale-admin.apps.ocp4.datr.eu"
```

## List Services

```
3scale service list 3scale
```

## New Service

```
3scale import openapi \
    -d 3scale \
    product_openapi3.yaml \
    --override-private-base-url=http://product-amazin-quarkus.apps.ocp4.datr.eu \
    -t product-catalog \
    --default-credentials-userkey=monkey123
```

## Delete Service

```
3scale service delete 3scale product-catalog
```

## Create an Application Plan

```
3scale application-plan apply 3scale product-catalog product-plan -n "Product Plan" --default
```

## Create a Client Application

```
3scale account find  3scale admin+test@3scale.apps.ocp4.datr.eu -a
id => 3
org_name => Developer
created_at => 2020-04-17T15:25:30Z
updated_at => 2020-04-17T15:25:33Z
admin_domain => 
domain => 
from_email => 
support_email => 
finance_support_email => 
monthly_billing_enabled => true
monthly_charging_enabled => true

3scale application apply 3scale-saas amazin-mobile-api-key --account=3 --name="Amazin Mobile Application" --description="Created from the CLI" --plan=product-plan --service=product-catalog
```

## Test API

```
STAGING_URL=$(3scale proxy-config show 3scale product-catalog sandbox | jq -r .content.proxy.sandbox_endpoint)

curl "https://product-catalog-3scale-apicast-staging.apps.ocp4.datr.eu:443/products/all?user_key=amazin-mobile-api-key"
```