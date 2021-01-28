FROM registry.access.redhat.com/openshift3/jenkins-2-rhel7:v3.10

MAINTAINER Justin

USER root

ADD certificates/datr.crt /etc/pki/ca-trust/source/anchors/datr.crt

RUN update-ca-trust

# Import Root CA and subordinate certificates into Java keystore
ADD certificates/datr.crt /tmp
RUN JAVA_HOME=$( dirname $( dirname $( readlink -f $( which javac ) ) ) ) && \
    ${JAVA_HOME}/bin/keytool \
    -keystore ${JAVA_HOME}/jre/lib/security/cacerts \
    -storepass changeit \
    -import \
    -trustcacerts \
    -noprompt \
    -alias firewall \
    -file /tmp/datr.crt

USER 1001
