https://github.com/tektoncd/pipeline

oc new-project tekton-test

oc apply -f helloword_task.yaml

oc apply -f helloworld_taskrun.yaml