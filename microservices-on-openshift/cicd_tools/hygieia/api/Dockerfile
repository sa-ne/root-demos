FROM docker-registry.default.svc:5000/openshift/java

MAINTAINER Justin Davis

EXPOSE 8080

ENV TZ Europe/London

COPY api.jar .
COPY api.properties .

ENTRYPOINT [ "sh", "-c", "java -jar  /home/jboss/api.jar --spring.config.location=/home/jboss/api.properties -Djasypt.encryptor.password=hygieiasecret" ]