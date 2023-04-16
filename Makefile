include env.sh

# make docker
SHELL := /bin/bash
ifndef TARGET
TARGET := latest
endif

.base_env: 
	source ./env.sh && docker login $(DOCKER_REGISTRY) -u $(DOCKER_USER) -p $(DOCKER_PASS)

all: devenv js_env

up: .base_env
	docker pull $(DOCKER_REGISTRY)/$(DOCKER_NAMESPACE)/devenv:$(TARGET)
	docker run -v /home:/home -p 2222:22 --name devenv -d $(DOCKER_REGISTRY)/$(DOCKER_NAMESPACE)/devenv:$(TARGET)

devenv: .base_env 
	docker build -t devenv:latest . -f default_dev.dockerfile
	docker tag devenv:latest $(DOCKER_REGISTRY)/$(DOCKER_NAMESPACE)/devenv:latest
	docker push $(DOCKER_REGISTRY)/$(DOCKER_NAMESPACE)/devenv:latest

js_env: .base_env 
	docker build -t devenv:js . -f js_dev.dockerfile
	docker tag devenv:js $(DOCKER_REGISTRY)/$(DOCKER_NAMESPACE)/devenv:js
	docker push $(DOCKER_REGISTRY)/$(DOCKER_NAMESPACE)/devenv:js


