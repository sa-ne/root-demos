FROM registry.redhat.io/openshift4/ose-jenkins-agent-maven

USER root

WORKDIR /opt 

RUN wget https://apache.mirrors.nublue.co.uk/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz >/dev/null 2>&1 \
    && tar zxvf apache-maven-3.6.3-bin.tar.gz \
    && ln -s apache-maven-3.6.3 maven

ENV M2_HOME=/opt/maven

RUN wget https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-20.0.0/graalvm-ce-java11-linux-amd64-20.0.0.tar.gz >/dev/null 2>&1 \
    && tar zxvf graalvm-ce-java11-linux-amd64-20.0.0.tar.gz

ENV GRAALVM_HOME=/opt/graalvm-ce-java11-20.0.0
ENV PATH=$GRAALVM_HOME/bin:$M2_HOME/bin:$PATH

RUN gu install native-image

RUN yum -y install gcc gcc-c++ glibc-devel libstdc++-devel libstdc++ zlib zlib-devel

RUN  wget https://github.com/argoproj/argo-cd/releases/download/v1.5.1/argocd-linux-amd64 \
    && cp argocd-linux-amd64 /usr/local/bin/argocd \
    && rm -rf argocd-linux-amd64 \
    && chmod 777 /usr/local/bin/argocd

RUN wget https://github.com/mikefarah/yq/releases/download/3.2.1/yq_linux_amd64 \
     && cp yq_linux_amd64 /usr/local/bin/yq \
     && chmod 777 /usr/local/bin/yq

RUN wget https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.5.4/kustomize_v3.5.4_linux_amd64.tar.gz \
    && tar zxvf kustomize_v3.5.4_linux_amd64.tar.gz \
    && cp kustomize /usr/local/bin/kustomize \
    && chmod 777 /usr/local/bin/kustomize    

RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

USER 1001