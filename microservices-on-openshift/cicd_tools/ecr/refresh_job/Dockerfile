FROM centos:7

RUN yum update -y
RUN yum install -y epel-release wget
RUN yum install -y python
RUN yum install -y python-pip

RUN pip install awscli

WORKDIR /tmp

RUN wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz && \
    tar zxvf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz && \
    cd openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit && \
    cp oc /usr/bin && \
    chmod 777 /usr/bin/oc

RUN groupadd -r aws && useradd -r -u 1001 -g aws -d /home/aws aws

RUN mkdir -p .aws
COPY config /home/aws/.aws/
COPY credentials /home/aws/.aws/

RUN chown -R aws:aws /home/aws

ENTRYPOINT ["/bin/sh","-c"]
CMD [""]
USER aws
WORKDIR /home/aws