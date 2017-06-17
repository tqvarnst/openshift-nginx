FROM docker.io/centos:7

MAINTAINER NGINX Docker Maintainers "docker-maint@nginx.com"

ENV NGINX_VERSION 1.13.1-1.el7

LABEL name="nginxinc/nginx" \
      vendor="NGINX Inc." \
      version="${NGINX_VERSION}" \
      release="1" \
      summary="NGINX" \
      description="nginx will do ....." \
### Required labels above - recommended below
      url="https://www.nginx.com/" \
      io.k8s.display-name="NGINX" \
      io.openshift.expose-services="http,https" \
      io.openshift.tags="nginx,nginxinc"
#      run='docker run -tdi --name ${NAME} \
#        -u $(id -u) \
#        -p 80:8080 \
#        -v $(mktemp -d /tmp/nginx.XXXXX):/var/cache/nginx:Z \
#        ${IMAGE}' \
#      io.k8s.description="Starter app will do ....." \

ADD nginx.repo /etc/yum.repos.d/nginx.repo

RUN curl -sO http://nginx.org/keys/nginx_signing.key && \
    rpm --import ./nginx_signing.key && \
    yum -y install --setopt=tsflags=nodocs nginx-${NGINX_VERSION}.ngx && \
    rm -f ./nginx_signing.key && \
    yum clean all

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# change pid file location & port to 8080
RUN sed -i -e '/pid/!b' -e '/\/var\/run\/nginx.pid/!b' -e '/\/var\/run\/nginx.pid/d' /etc/nginx/nginx.conf && \
    sed -i -e '/listen/!b' -e '/80;/!b' -e 's/80;/8080;/' /etc/nginx/conf.d/default.conf

VOLUME ["/var/cache/nginx"]

EXPOSE 8080 8443

USER 998

CMD ["nginx", "-g", "daemon off; pid /var/cache/nginx/nginx.pid;"]
