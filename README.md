# OpenShift NGINX Docker Image

This Dockerfile creates an OpenShift compatible NGINX Docker image. Notable differences with respect to the official NGINX Docker image include:
* NGINX now listens on port 8080 insteand of port 80
* User directive in `/etc/nginx/nginx.conf` has been removed
* The default nginx pid has been moved from `/var/run/nginx.pid` to `/var/cache/nginx/nginx.pid`
