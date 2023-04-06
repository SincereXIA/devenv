# make docker
SHELL := /bin/bash

.base_env: 
	docker login $(DOCKER_REGISTRY) -u $(DOCKER_USER) -p $(DOCKER_PASS)

all: devenv js_env

devenv: .base_env 
	docker build -t devenv:latest . -f default_dev.dockerfile
	docker tag devenv:latest $(DOCKER_REGISTRY)/devenv:latest
	docker push $(DOCKER_REGISTRY)/devenv:latest

js_env: .base_env 
	docker build -t devenv:js . -f js_dev.dockerfile
	docker tag devenv:js $(DOCKER_REGISTRY)/devenv:js
	docker push $(DOCKER_REGISTRY)/devenv:js


