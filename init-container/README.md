## Execution

Create the pod:

```shell
oc create -f myapp.yaml
```

View the status of the pod:

```shell
oc get pods
NAME                          READY     STATUS              RESTARTS   AGE
myapp-pod                     0/1       Init:0/2            0          5s
```

Note that the pod status indicates it is waiting.

Run the commands to create the services:

```shell
oc create -f mydb.yaml
oc create -f myservice.yaml
```

View the status of the pod again:

```shell
oc get pods
NAME                          READY     STATUS              RESTARTS   AGE
myapp-pod                     1/1       Running             0          2m
```
