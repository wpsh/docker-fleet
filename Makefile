#!/usr/bin/make -f

BUILD_REV=$(shell git rev-parse --short HEAD)
BUILD_DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

# See https://www.gnu.org/software/make/manual/html_node/Phony-Targets.html
.PHONY: all clean test lint version

all: help

help:
	@echo "See the commands defined in the Makefile."

version:
	@docker --version
	@docker-compose --version
	@make --version

images.build:
	find ./containers -type f -name docker-compose.build.yml -exec \
		docker-compose --file {} build --parallel \;

images.clean:
	find . -type f -name docker-compose*.yml -exec \
		docker-compose --file {} rm --force -v \;

images.push: images.build
	find ./containers -type f -name docker-compose.build.yml -exec \
		docker-compose --file {} push \;

images.test:
	find ./containers -type f -name docker-compose.test.yml -exec \
		docker-compose --file {} up --remove-orphans --build --renew-anon-volumes --exit-code-from sut sut \;

lint.dockerfile:
	docker-compose run lint-dockerfile

lint.docker-compose:
	find . -type f -name docker-compose*.yml -exec \
		docker-compose --file {} config --quiet \;

lint.yaml:
	docker-compose run lint-yaml

lint.makefile:
	docker-compose run lint-makefile

lint.all: lint.docker-compose lint.dockerfile lint.yaml lint.makefile

lint: lint.all
