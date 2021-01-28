FROM openshift/jenkins-slave-base-centos7

LABEL date=06/04/18
LABEL nodejs.version=6.12.3
LABEL npm.version=3.10.10

RUN yum install -y epel-release && yum install -y --setopt=tsflags=nodocs nodejs npm && \
    rpm -V nodejs npm && \
    yum clean all -y

RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

USER 1001
