CONTEXT = nginxinc
VERSION = 1.13.1
IMAGE_NAME = openshift-nginx

# Allow user to pass in OS build options
ifeq ($(TARGET),rhel7)
	DFILE := Dockerfile.${TARGET}
else
	TARGET := centos7
	DFILE := Dockerfile
endif

all: build
build:
	docker build --pull -t ${CONTEXT}/${IMAGE_NAME}:${TARGET}-${VERSION} -t ${CONTEXT}/${IMAGE_NAME} -f ${DFILE} .
	@if docker images ${CONTEXT}/${IMAGE_NAME}:${TARGET}-${VERSION}; then touch build; fi

lint:
	dockerfile_lint -f Dockerfile
	dockerfile_lint -f Dockerfile.rhel7

test:
	$(eval TMPDIR=$(shell mktemp -d /tmp/nginx.XXXXX))
	$(eval CONTAINERID=$(shell docker run -tdi -u $(shell id -u) -v ${TMPDIR}:/var/cache/nginx:Z nginxinc/openshift-nginx))
	@docker exec ${CONTAINERID} curl localhost:8080
	@docker rm -f ${CONTAINERID}
	@rm -r ${TMPDIR}

run:
	$(eval TMPDIR=$(shell mktemp -d /tmp/nginx.XXXXX))
	docker run -tdi -u $(shell id -u) -p 8080:8080 -v ${TMPDIR}:/var/cache/nginx:Z nginxinc/openshift-nginx

clean:
	rm -f build