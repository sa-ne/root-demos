# Kaniko : Building container Images from within a Container

A failed attempt to user the builder-dockercfg secret to allow kaniko to push to local registry. Didnt work secret wrong structure :

```
{
  "172.30.57.99:5000": {
    "username": "serviceaccount",
    "password": "...",
    "email": "serviceaccount@example.org",
    "auth": "..."
  },
  "docker-registry.default.svc.cluster.local:5000": {
    "username": "serviceaccount",
    "password": "...",
    "email": "serviceaccount@example.org",
    "auth": "..."
   },
  "docker-registry.default.svc:5000": {
    "username": "serviceaccount",
    "password": "...",
    "email": "serviceaccount@example.org",
    "auth": "..."
   }
}
```

when actually this is required :

```
{
  "auths": {
    "docker-registry.default.svc.cluster.local:5000": {
      "username": "serviceaccount",
      "password": "......",
      "email": "serviceaccount@example.org"
    }
  }
}
```

anyway there's an example of how to mount a secret as a file and then give it a custom name.


```
        volumes:
          - name: docker-config-secret-volume
            secret:
              items:
                - key: .dockercfg
                  path: config.json
              secretName: ${BUILDER_SECRET}

```