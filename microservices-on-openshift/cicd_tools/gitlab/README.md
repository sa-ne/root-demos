adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:gitlab:gitlab-ce-user

oc project gitlab-managed-apps

oc adm policy add-scc-to-user nonroot system:serviceaccount:gitlab-managed-apps:runner-gitlab-runner

oc adm policy add-scc-to-user privileged system:serviceaccount:gitlab-managed-apps:runner-gitlab-runner