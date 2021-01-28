https://github.com/tektoncd/pipeline

oc apply --filename https://storage.googleapis.com/tekton-releases/latest/release.yaml

oc new-project tekton-example

oc apply -f git_resource.yaml

oc apply -f image_resource.yaml

oc apply -f build_task.yaml

oc apply -f build_taskrun.yaml