FROM registry.access.redhat.com/ubi8/ubi

RUN yum --disableplugin=subscription-manager install httpd -y && yum --disableplugin=subscription-manager clean all

RUN sed -i 's/Listen 80/Listen 8080/'  /etc/httpd/conf/httpd.conf  && chgrp -R 0 /var/log/httpd /var/run/httpd  && chmod -R g=u /var/log/httpd /var/run/httpd && echo "Azure Red Hat OpenShift" > /var/www/html/index.html
# EXPOSE 8080
# USER 1001
# CMD /usr/sbin/httpd -D FOREGROUND

# COPY ./etc-pki-entitlement /etc/pki/entitlement
# COPY ./rhsm-conf /etc/rhsm
# COPY ./rhsm-ca /etc/rhsm/ca

EXPOSE 8080
EXPOSE 8443

ENV NAME=nginx \
    NGINX_VERSION=1.16 \
    NGINX_SHORT_VER=116 \
    VERSION=0

# RUN rm /etc/rhsm-host && subscription-manager repos \
#     --disable=rhel-7-server-htb-rpms \
#     --enable="rhel-7-server-rpms" \
#     --enable="rhel-7-server-extras-rpms"    

ENV NGINX_CONFIGURATION_PATH=${APP_ROOT}/etc/nginx.d \
    NGINX_CONF_PATH=/etc/nginx/nginx.conf \
    NGINX_DEFAULT_CONF_PATH=${APP_ROOT}/etc/nginx.default.d \
    NGINX_CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/nginx \
    NGINX_APP_ROOT=${APP_ROOT} \
    NGINX_LOG_PATH=/var/log/nginx \
    NGINX_PERL_MODULE_PATH=${APP_ROOT}/etc/perl

RUN yum -y update && yum -y install nginx && \
    INSTALL_PKGS="nss_wrapper bind-utils gettext hostname nginx nginx-mod-stream nginx-mod-http-perl" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*'

RUN sed -i -f ${NGINX_APP_ROOT}/nginxconf-fed.sed ${NGINX_CONF_PATH} && \
    chmod a+rwx ${NGINX_CONF_PATH} && \
    mkdir -p ${NGINX_APP_ROOT}/etc/nginx.d/ && \
    mkdir -p ${NGINX_APP_ROOT}/etc/nginx.default.d/ && \
    mkdir -p ${NGINX_APP_ROOT}/src/nginx-start/ && \
    mkdir -p ${NGINX_CONTAINER_SCRIPTS_PATH}/nginx-start && \
    mkdir -p ${NGINX_LOG_PATH} && \
    mkdir -p ${NGINX_PERL_MODULE_PATH} && \
    chmod -R a+rwx ${NGINX_APP_ROOT}/etc && \
    chmod -R a+rwx /var/lib/nginx && \
    chmod -R a+rwx ${NGINX_CONTAINER_SCRIPTS_PATH}/nginx-start && \
    chown -R 1001:0 ${NGINX_APP_ROOT} && \
    chown -R 1001:0 /var/lib/nginx && \
    chown -R 1001:0 ${NGINX_CONTAINER_SCRIPTS_PATH}/nginx-start && \
    # FIXME: Not sure if this is safe to do, just a hack to make the image work
    chmod -R a+rwx /var/run && \
    chown -R 1001:0 /var/run && \
    rpm-file-permissions

USER 1001    

CMD ["nginx", "-g", "daemon off;"]