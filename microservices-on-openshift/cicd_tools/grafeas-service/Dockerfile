FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift

MAINTAINER Justin Davis

EXPOSE 8080

ENV TZ Europe/London
ENV SERVICE_ARTIFACT_ID=grafeas
ENV SERVICE_VERSION=1.0
ENV SERVICE_JAR_FILE=$SERVICE_ARTIFACT_ID-$SERVICE_VERSION.jar

COPY target/$SERVICE_JAR_FILE .

ENV JAVA_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=1"

ENTRYPOINT [ "sh", "-c", "java -Djava.security.egd=file:/dev/./urandom $JAVA_OPTS -jar $SERVICE_JAR_FILE" ]