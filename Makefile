include .env

.DEFAULT_GOAL := help
.PHONY: build

help:  ## show this help message
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-30s\033[0m %s\n", $$1, $$2}'

build: ## build environment and initialize composer and project dependencies
	docker build .docker/php$(DOCKER_PHP_VERSION)-fpm/ \
		-t $(DOCKER_SERVER_HOST)/$(DOCKER_PROJECT_PATH)/php$(DOCKER_PHP_VERSION)-fpm:$(DOCKER_IMAGE_VERSION) \
		--build-arg DOCKER_SERVER_HOST=$(DOCKER_SERVER_HOST) \
		--build-arg DOCKER_PROJECT_PATH=$(DOCKER_PROJECT_PATH) \
		--build-arg DOCKER_PHP_VERSION=$(DOCKER_PHP_VERSION) \
		--build-arg DOCKER_IMAGE_VERSION=$(DOCKER_IMAGE_VERSION)

	docker build .docker/php$(DOCKER_PHP_VERSION)-composer/ \
		-t $(DOCKER_SERVER_HOST)/$(DOCKER_PROJECT_PATH)/php$(DOCKER_PHP_VERSION)-composer:$(DOCKER_IMAGE_VERSION) \
		--build-arg DOCKER_SERVER_HOST=$(DOCKER_SERVER_HOST) \
		--build-arg DOCKER_PROJECT_PATH=$(DOCKER_PROJECT_PATH) \
		--build-arg DOCKER_PHP_VERSION=$(DOCKER_PHP_VERSION) \
		--build-arg DOCKER_IMAGE_VERSION=$(DOCKER_IMAGE_VERSION)

	docker build .docker/php$(DOCKER_PHP_VERSION)-dev/ -t $(DOCKER_SERVER_HOST)/$(DOCKER_PROJECT_PATH)/php$(DOCKER_PHP_VERSION)-dev:$(DOCKER_IMAGE_VERSION) \
		--build-arg DOCKER_SERVER_HOST=$(DOCKER_SERVER_HOST) \
		--build-arg DOCKER_PROJECT_PATH=$(DOCKER_PROJECT_PATH) \
		--build-arg DOCKER_PHP_VERSION=$(DOCKER_PHP_VERSION) \
		--build-arg DOCKER_IMAGE_VERSION=$(DOCKER_IMAGE_VERSION)

	docker-compose build --pull

down:
	docker-compose down

up:
	docker-compose up -d