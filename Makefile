#!/usr/bin/make -f

-include .env .env.local

BUILD_REV=$(shell git rev-parse --short HEAD)
BUILD_DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

all: help

help:
	@echo "See the commands defined in the Makefile."

lint:
	docker-compose run hadolint

build:
	docker-compose --file containers/*/docker-compose.build.yml build

push:
	docker-compose --file containers/*/docker-compose.build.yml push

clean:
	docker-compose --file containers/*/docker-compose.build.yml clean

test:
	docker-compose --file containers/*/docker-compose.test.yml run \
	--rm --build --renew-anon-volumes --exit-code-from \
	sut
