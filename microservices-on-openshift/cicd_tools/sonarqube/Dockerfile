FROM jboss/base-jdk:11

ENV SONAR_VERSION=$SONARQUBE_VERSION \
    SONARQUBE_HOME=/opt/sonarqube \
    SONARQUBE_JDBC_USERNAME=sonar \
    SONARQUBE_JDBC_PASSWORD=sonar \
    SONARQUBE_JDBC_URL=unknown

# Http port
EXPOSE 9000

USER root

RUN groupadd -r sonarqube && useradd -r -g sonarqube sonarqube


RUN set -x \
    && cd /opt \
    && curl -o sonarqube.zip -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && unzip sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION sonarqube \
    && chown -R sonarqube:sonarqube sonarqube \
    && rm sonarqube.zip* \
    && touch /opt/sonarqube/temp/README.txt \
    && rm -rf $SONARQUBE_HOME/bin/*

VOLUME "$SONARQUBE_HOME/data"
VOLUME "$SONARQUBE_HOME/extensions"

COPY run.sh $SONARQUBE_HOME/bin/
RUN chown -R sonarqube:sonarqube $SONARQUBE_HOME && chmod -R 777 $SONARQUBE_HOME
USER sonarqube
WORKDIR $SONARQUBE_HOME
ENTRYPOINT ["./bin/run.sh"]