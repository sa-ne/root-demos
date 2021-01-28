FROM registry.access.redhat.com/fuse7/fuse-java-openshift:1.1-4

MAINTAINER Justin Davis

EXPOSE 8080

ENV TZ Europe/London

USER root

RUN mkdir -p /deployments/keys && mkdir -p /deployments/files && chmod -R 777 /deployments/files

COPY target/camel-test-1.0.jar /deployments

USER 0

ENTRYPOINT [ "sh", "-c", "java -jar /deployments/camel-test-1.0.jar" ]

