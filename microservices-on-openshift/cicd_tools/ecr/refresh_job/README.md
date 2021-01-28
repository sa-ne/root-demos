#Job to refresh AWS Docker Registry credentials.

Docker credrentials for ECR need to be refreshed every 12 hours.

Thus if OCP is to use ECR as its registry, its image push/pull secrets need to be updated every 12 hrs.

The resources in this folder make that possible as a kubernetes CronJob.

Create a project where this job runs, and configure a service-account so that the cronjob pod can run the container as the user that owns the AWS credentials (999). Give the service account privileges to run non-root containers

Also configure the user to have secret create and delete privileges : in this case project admin

#Test this wiyj something like :

oc import-image grafeas --from=005459661421.dkr.ecr.eu-west-1.amazonaws.com/dev/grafeas:latest --confirm

this command will fail intil this job has run atleast once 


##Create Project
oc new-project ecr-admin

##Run as correct user in container
oc adm policy add-scc-to-user nonroot system:serviceaccount:ecr-admin:default

##Create delete secrets
oc adm policy add--role-to-user admin system:serviceaccount:ecr-admin:default

##Build and push image
./build.sh

##Deploy CronJob
oc create -f aws.cron.yml

