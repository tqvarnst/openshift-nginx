```shell
# build on centos7
$ make

# OR

# build on rhel7
$ make TARGET=rhel7
```
```shell
$ docker run -tdi -u $(id -u) -p 80:8080 -v $(mktemp -d /tmp/nginx.XXXXX):/var/cache/nginx:Z nginxinc/openshift-nginx
$ curl localhost
```