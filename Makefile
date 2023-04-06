# make docker
SHELL := /bin/bash

.base_env: 
	source ./env.sh && docker login $(DOCKER_REGISTRY) -u $(DOCKER_USER) -p $(DOCKER_PASS)

all: devenv js_env

devenv: .base_env 
	docker build -t devenv:latest . -f default_dev.dockerfile
	docker tag devenv:latest $(DOCKER_REGISTRY)/$(DOCKER_NAMESPACE)/devenv:latest
	docker push $(DOCKER_REGISTRY)/$(DOCKER_NAMESPACE)/devenv:latest

js_env: .base_env 
	docker build -t devenv:js . -f js_dev.dockerfile
	docker tag devenv:js $(DOCKER_REGISTRY)/$(DOCKER_NAMESPACE)/devenv:js
	docker push $(DOCKER_REGISTRY)/$(DOCKER_NAMESPACE)/devenv:js


