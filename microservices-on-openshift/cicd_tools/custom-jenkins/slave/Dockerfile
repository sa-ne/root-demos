FROM registry.access.redhat.com/openshift3/jenkins-slave-base-rhel7:v3.6.173.0.49-5

WORKDIR /home/jenkins

# Set the timezone and locale
RUN ln -snf /usr/share/zoneinfo/UTC /etc/localtime && \
    echo UTC | tee /etc/timezone                   && \
    localedef -c -i en_GB -f UTF-8 en_GB.utf-8

# Disable RealTime YUM repositories (DOES NOT WORK ON OSMO)
# RUN yum-config-manager --disable rhel-7-server-rt-beta-rpms || : && \
#     yum-config-manager --disable rhel-7-server-rt-rpms      || : && \
#     yum-config-manager --disable epel > /dev/null           || : && \
#     yum -y update

ENV DISABLED_REPOS=--disablerepo=rhel-7-server-rt-beta-rpms,rhel-7-server-rt-rpms

RUN yum -y update ${DISABLED_REPOS}

# Set versions
ENV JAVA_VERSION=1.8.0    \
    MAVEN_VERSION=3.3.9   \
    GRADLE_VERSION=3.5    \
    NODEJS_VERSION=8.11.3 \
    ONE_PASSWORD_CLI_VERSION=v0.5.1

# Install OpenJDK
RUN INSTALL_PKGS="java-${JAVA_VERSION}-openjdk-devel.x86_64 java-${JAVA_VERSION}-openjdk-devel.i686" && \
    yum -y install $INSTALL_PKGS ${DISABLED_REPOS}                                                   && \
    rpm -V ${INSTALL_PKGS//\*/}

# Install NodeJS
# [ToDo]: Install Node.js 6.x and PhantomJS?
RUN curl --silent --location https://rpm.nodesource.com/setup_8.x | bash - && \
    yum -y install nodejs-${NODEJS_VERSION}-1nodesource.x86_64 ${DISABLED_REPOS}
ENV PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH
RUN node --version && \
    npm --version

# Install Chrome
ADD contrib/etc/yum.repos.d/google-chrome.repo /etc/yum.repos.d/
RUN INSTALL_PKGS="GConf2 google-chrome-stable"     && \
    yum -y install $INSTALL_PKGS ${DISABLED_REPOS} && \
    rm -rf $HOME/.pki
RUN google-chrome-stable --version

ENV MAVEN_HOME=/opt/apache-maven-${MAVEN_VERSION} \
    MAVEN_USER_HOME=$HOME/.m2                     \
    MAVEN_BASEDIR=$HOME                           \
    GRADLE_HOME=/opt/gradle-${GRADLE_VERSION}     \
    GRADLE_USER_HOME=$HOME/.gradle/               \
    NPM_CONFIG_PREFIX=$HOME/.npm-global

ENV PATH=$HOME:${MAVEN_HOME}/bin:${GRADLE_HOME}/bin:$PATH

# Install Maven
RUN curl -LOk https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    tar xzf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /opt                                                                   && \
    rm apache-maven-${MAVEN_VERSION}-bin.tar.gz                                                                                && \
    mkdir -p $HOME/.m2
RUN mvn --version

# Install Gradle
RUN curl -LOk https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip gradle-${GRADLE_VERSION}-bin.zip -d /opt                                       && \
    rm -f gradle-${GRADLE_VERSION}-bin.zip
RUN gradle --version

# Copy Maven and Gradle Wrappers
ADD contrib/home/jenkins/ $HOME/
RUN chmod ugo+x $HOME/mvnw    && \
    chmod ugo+x $HOME/gradlew
RUN mvnw --version
RUN gradlew --version

# Include EPEL packages
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Install jq
RUN yum -y install jq
RUN jq --version

# Install 1Password CLI
RUN curl -o 1password.zip https://cache.agilebits.com/dist/1P/op/pkg/${ONE_PASSWORD_CLI_VERSION}/op_linux_amd64_${ONE_PASSWORD_CLI_VERSION}.zip && \
    unzip 1password.zip -d /usr/local/bin                                                                                                       && \
    rm 1password.zip
RUN op --version || :

# Add environment variables to profile
RUN export MAVEN_HOME=$HOME/$( dirname $( dirname $( find .m2/wrapper/dists/ -name mvn ) ) )         && \
    export GRADLE_HOME=$HOME/$( dirname $( dirname $( find .gradle/wrapper/dists/ -name gradle ) ) ) && \
    printf $"\
export MAVEN_HOME=${MAVEN_HOME}                        \n\
export GRADLE_HOME=${GRADLE_HOME}                      \n\
export PATH=${MAVEN_HOME}/bin:${GRADLE_HOME}/bin:$PATH \n\
" | tee /etc/profile.d/jenkins.sh

# Configure owner and permissions under /home/jenkins/
RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

# Cleanup YUM
RUN yum clean all -y && rm -rf /var/cache/yum

# Import Amazon RDS certificate into Java keystore
ADD contrib/certificates/rds-combined-ca-bundle.pem /tmp
RUN JAVA_HOME=$( dirname $( dirname $( readlink -f $( which javac ) ) ) ) && \
    keytool -keystore ${JAVA_HOME}/jre/lib/security/cacerts -storepass changeit -import -noprompt -alias rds_ca -file /tmp/rds-combined-ca-bundle.pem

USER 1001
