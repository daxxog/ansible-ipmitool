SHELL := /bin/bash

.PHONY: help
help:
	@printf "available targets -->\n\n"
	@cat Makefile | grep ".PHONY" | grep -v ".PHONY: _" | sed 's/.PHONY: //g'


.PHONY: docker-build
docker-build:
	docker build . -t docker.io/daxxog/ipmitool:latest-$$(uname -m)


.PHONY: docker-tag
docker-tag: docker-build _need-build-number
	docker tag docker.io/daxxog/ipmitool:latest-$$(uname -m) docker.io/daxxog/ipmitool:$$(cat BUILD_NUMBER)-$$(uname -m)
	@echo docker tag docker.io/daxxog/ipmitool:latest-$$(uname -m) docker.io/daxxog/ipmitool:$$(cat BUILD_NUMBER)-$$(uname -m)


.PHONY: _need-build-number
_need-build-number:
	if [ ! -f BUILD_NUMBER ]; then \
		make version-bump; \
	fi


.PHONY: version-bump
version-bump:
	dc --version
	touch BUILD_NUMBER
	echo "$$(cat BUILD_NUMBER) 1 + p" | dc | tee _BUILD_NUMBER
	mv _BUILD_NUMBER BUILD_NUMBER


.PHONY: docker-push
docker-push: docker-tag
	docker push docker.io/daxxog/ipmitool:$$(cat BUILD_NUMBER)-$$(uname -m)
	docker push docker.io/daxxog/ipmitool:latest-$$(uname -m)


.PHONY: docker-shell
docker-shell: docker-build
	docker run \
		-i \
		-t \
		--entrypoint /bin/zsh \
		docker.io/daxxog/ipmitool:latest-$$(uname -m)
