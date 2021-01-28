# s2i-4-java
FROM  centos:7

MAINTAINER Justin Davis <justinndavis@gmail.com>

EXPOSE 8080

ENV BUILDER_VERSION 1.0
ENV JAVA_VERSON 1.8.0
ENV MAVEN_VERSION 3.3.9

LABEL name="Centos Java Image" \
      vendor=jnd.org \
      license=GPLv2

LABEL io.k8s.description="Image for building java micro-service apps" \
      io.k8s.display-name="Base Centos Java" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,java,http" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"


RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm && \
 yum -y install wget curl java-$JAVA_VERSON-openjdk-devel git ansible pyOpenSSL libxml2 libxslt && \
 yum clean all -y && \
 rm -rf /var/cache/yum && \
 mkdir -p /app && \
 mkdir -p /log && \
 mkdir -p /data

WORKDIR /app

RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV JAVA_HOME /usr/lib/jvm/java
ENV MAVEN_HOME /usr/share/maven

RUN mkdir -p /usr/libexec/s2i

COPY .s2i/bin /usr/libexec/s2i

RUN groupadd -r service && useradd -u 1001 -g service service

RUN chown -R service:service /app && \
    chown -R service:service /log && \
    chown -R service:service /data && \
    chmod -R 777 /log && \
    chmod -R 777 /app

USER 1001

CMD ["/usr/libexec/s2i/usage"]