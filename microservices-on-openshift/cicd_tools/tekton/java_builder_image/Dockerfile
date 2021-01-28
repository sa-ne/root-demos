# s2i-4-java
FROM  centos:7

MAINTAINER Justin Davis <justinndavis@gmail.com>

EXPOSE 8080

ENV BUILDER_VERSION 1.0
ENV JAVA_VERSON 1.8.0
ENV MAVEN_VERSION 3.6.1

LABEL name="Java Builder Image" \
      vendor=jnd.org \
      license=GPLv2

LABEL io.k8s.description="Image for building java micro-service apps" \
      io.k8s.display-name="Base Centos Java" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,java,http" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"


RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm && \
 yum -y install wget curl java-$JAVA_VERSON-openjdk-devel git libxml2 libxslt && \
 yum clean all -y && \
 rm -rf /var/cache/yum && \
 mkdir -p /workspace

WORKDIR /app

RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV JAVA_HOME /usr/lib/jvm/java
ENV MAVEN_HOME /usr/share/maven
ENV HOME /workspace

RUN groupadd -r builder && useradd -d $HOME -u 1001 -g builder builder

RUN chown -R builder:builder /workspace && \
    chmod -R 777 /workspace

USER root

CMD ["mvn"]