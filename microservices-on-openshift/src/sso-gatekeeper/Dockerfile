FROM centos

RUN yum install -y wget
WORKDIR /
RUN wget https://downloads.jboss.org/keycloak/4.8.3.Final/gatekeeper/keycloak-gatekeeper-linux-amd64.tar.gz
RUN tar zxvf keycloak-gatekeeper-linux-amd64.tar.gz && ls -ltr && rm -rf keycloak-gatekeeper-linux-amd64.tar.gz

#COPY config/gatekeeper.yaml /gatekeeper.yaml

FROM scratch
WORKDIR /
COPY --from=0 /keycloak-gatekeeper /keycloak-gatekeeper
#COPY --from=0 /gatekeeper.yaml /etc/gatekeeper.yaml

CMD ["/keycloak-gatekeeper", "-config", "/app/etc/gatekeeper.yaml"]