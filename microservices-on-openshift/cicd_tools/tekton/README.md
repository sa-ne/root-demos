# Tekton

https://github.com/tektoncd/pipeline

https://github.com/tektoncd/pipeline/blob/master/docs/install.md

## Operator Installation

oc new-project tekton-pipelines
oc adm policy add-scc-to-user anyuid -z tekton-pipelines-controller
oc apply --filename https://storage.googleapis.com/tekton-releases/latest/release.yaml

## Dashboard Installation

### Deployment Scaffolding

oc process -f https://raw.githubusercontent.com/tektoncd/dashboard/master/config/templates/deploy.yaml | oc apply -f-

### Docker Build Config that will provide the image to be deployed

oc process -f https://raw.githubusercontent.com/tektoncd/dashboard/master/config/templates/build.yml | oc apply -f-

oc start-build "tekton-dashboard" -f

#### RBAC for dashboard

Allow dashboard to see cluster

oc adm policy add-cluster-role-to-user cluster-reader -z default


### Tutorial

https://github.com/tektoncd/pipeline/blob/master/docs/tutorial.md

oc new-project tekton-tutorial

oc apply -f helloworld/helloword_task.yaml

oc apply -f helloworld/helloworld_taskrun.yaml


### Examples

https://github.com/tektoncd/pipeline/tree/master/examples

oc new-project tekton-test


# To invoke the build-push Task only
oc apply -f https://github.com/tektoncd/pipeline/blob/master/examples/taskruns/taskrun.yaml

# To invoke the simple Pipeline
oc apply -f https://github.com/tektoncd/pipeline/blob/master/examples/pipelineruns/pipelinerun.yaml

# To invoke the Pipeline that links outputs
oc apply -f https://github.com/tektoncd/pipeline/blob/master/examples/pipelineruns/output-pipelinerun.yaml

# To invoke the TaskRun with embedded Resource spec and task Spec
kubectl apply -f https://github.com/tektoncd/pipeline/blob/master/examples/taskruns/git-resource-spec-taskrun.yaml