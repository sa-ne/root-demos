# s2i-test
Testing Openshift's S2i capability

https://github.com/justindav1s/s2i-java-base.git

Build a base image running Centos7/OpenJDK 7

Image built from Docker file

run :

make

or

docker build -t s2i-java-base .

Run the image locally on docker


docker run -d -p 8080:8080 java-service-base

Check :

Should get usage message

to run s2i to build something useful :

s2i build . java-service-base java-service-base-jenkins

then

docker run -d -p 8080:8080 java-service-base-jenkins

git clone https://github.com/justindav1s/s2i-java-base.git
cd s2i-ib-tomcat-base/
sudo docker build -t ib-tomcat-base .
sudo docker save ib-tomcat-base > ib-tomcat-base.tar
scp ib-tomcat-base.tar fedora@172.31.26.89:~/

sudo docker save ib-tomcat-base > ib-tomcat-base.tar

sudo docker load < ib-tomcat-base.tar

https://docs.openshift.com/enterprise/3.0/install_config/install/docker_registry.html

[fedora@ip-172-31-26-89 ~]$ sudo docker ps | grep origin-docker-registry
4ffcf611ec9e        openshift/origin-docker-registry:v1.2.0 "/bin/sh -c 'DOCKER_R"   51 minutes ago      Up 51 minutes                           k8s_registry.24455285_docker-registry-1-g0a30_default_0d408b03-7110-11e6-b6be-025ed4a15501_56306bfa
[fedora@ip-172-31-26-89 ~]$ docker exec -it 4ffcf611ec9e find /registry
/registry


[root@ip-172-31-26-89 ~]# oc login
Authentication required for https://ip-172-31-26-89.eu-west-1.compute.internal:8443 (openshift)
Username: justin
Password:
Login successful.

You have access to the following projects and can switch between them with 'oc project <projectname>':

  * default (current)
  * jc1
  * logging
  * management-infra
  * openshift
  * openshift-infra
  * test

Using project "default".
[root@ip-172-31-26-89 ~]# oc whoami -t

V2ifkPhcKgwKX3os9SnqP25G9UG1q7gWRotIbJt7i24


docker login -u <username> -e <any_email_address> -p <token_value> <registry_service_host:port>

get <registry_service_host:port> from registry pod in default project from console

docker login -p E-oIdm4pTrFKQ-K2pRCzsfyarWIo-PfOjKk0BK93Lmo -u justin docker-registry-default.apps.192.168.140.152.xip.io

docker login -p SU2AFOi26bZ3XbKWzwWjGYZqpLJEX0_47hMs5d8Y-5s -u justin docker-registry.default.svc:5000

docker tag s2i-java-base docker-registry-default.apps.192.168.140.152.xip.io/test/s2i-java-base

docker push docker-registry-default.apps.192.168.140.152.xip.io/test/s2i-java-base

oc new-app test/s2i-java-base~https://github.com/justindav1s/simple-java-service.git


Now visible amongst "other images"


docker pull centos/postgresql-94-centos7
docker images
oc whoami -t
docker login -u justin -e justin.davis@ba.com -p ........ 172.30.88.121:5000
docker tag centos/postgresql-94-centos7 172.30.88.121:5000/centos/postgresql-94-centos7

docker tag ib-services-base 172.30.88.121:5000/openshift/ib-services-base
docker push 172.30.88.121:5000/openshift/ib-services-base


https://forums.docker.com/t/command-to-remove-all-unused-images/20/5

docker rmi `docker images | awk '{ print $3; }'`


docker tag jd-tomcat docker-registry-default.apps.192.168.140.152.xip.io/test/jd-tomcat
docker push docker-registry-default.apps.192.168.140.152.xip.io/test/jd-tomcat

oc policy add-role-to-user \
    system:image-puller system:serviceaccount:test:default \
    --namespace=openshift
    
    
oc secrets new-dockercfg jd-pull-secret \
    --docker-server=docker-registry-default.apps.192.168.140.152.xip.io --docker-username=justin \
    --docker-password=ARNitmnX8hggAHQth24PX1-AFOzRCNaJXZzdNzWUCNs --docker-email=justinndavis@gmail.com 
      
yum groupremove 'X Window System' 'GNOME' 'multimedia' 'internet-browser' 'guest-agents' 'guest-desktop-agents' 'x11' 'print-client' 'dial-up'  
    
oc login
oc new-project test
oc whoami -t
docker login -p aHocJ1RMn5ppC8OAeVj8UJXzYxQQfZoI4aKNPK8e4cY  -u justin docker-registry-default.apps.192.168.140.152.xip.io
docker push docker-registry-default.apps.192.168.140.152.xip.io/test/s2i-java-base    