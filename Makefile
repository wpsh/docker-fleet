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
	@docker-compose \
		--file containers/*/docker-compose.build.yml \
		build

images.clean:
	@docker-compose \
		--file containers/*/docker-compose.build.yml \
		clean

images.push: images.build
	@docker-compose \
		--file containers/*/docker-compose.build.yml \
		push

images.test:
	@docker-compose \
		--file containers/*/docker-compose.test.yml \
		run --rm --build --renew-anon-volumes --exit-code-from \
		sut

lint.dockerfile:
	@docker-compose run lint-dockerfile

lint.docker-compose:
	@docker-compose \
		--file containers/*/docker-compose.build.yml \
		--file containers/*/docker-compose.test.yml \
		--file docker-compose.yml \
		config --quiet

lint.yaml:
	@docker-compose run lint-yaml

lint.makefile:
	@docker-compose run lint-makefile

lint.all: lint.docker-compose lint.dockerfile lint.yaml lint.makefile

lint: lint.all
