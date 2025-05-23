include .env

# REGISTRY: Where should Docker images be pushed once they're built?
REGISTRY := $(if $(REGISTRY),$(REGISTRY),localhost:5000)

# VERSION: If a git repository is not initialized version will be 0.0.0
VERSION := $(shell [ -d .git ] && git describe --tags --always --dirty)
VERSION := $(if $(VERSION),$(VERSION),0.0.0)
# OS: Used internally. Users should pass GOOS and/or GOARCH.
OS := $(if $(GOOS),$(GOOS),$(shell GOTOOLCHAIN=local go env GOOS))
# ARCH: Used internally. Users should pass GOOS and/or GOARCH.
ARCH := $(if $(GOARCH),$(GOARCH),$(shell GOTOOLCHAIN=local go env GOARCH))

IMAGE_TAG := $(VERSION)__$(OS)_$(ARCH)
GO_VERSION := 1.23
CONTAINER_IMAGE := golang:$(GO_VERSION)-alpine

all: # @HELP builds the docker image for our application
all:
	docker build \
		--progress=plain \
		--build-arg OS=$(OS) \
		--build-arg ARCH=$(ARCH) \
		-t $(REGISTRY)/$(IMAGE_NAME) \
		-f Dockerfile .

run: # @HELP run the application image locally with docker compose
	DOCKER_IMAGE=$(IMAGE_NAME) \
	REGISTRY=$(REGISTRY) \
	IMAGE_NAME=$(IMAGE_NAME) IMAGE_TAG=$(IMAGE_TAG) \
	ENVIRONMENT=docker-compose \
		docker compose up --build

release: # @HELP creates new release for TAG
	GITHUB_TOKEN=$(GITHUB_TOKEN) CR_PAT=$(GITHUB_TOKEN) \
    VERSION=$(VERSION) \
	REGISTRY=$(REGISTRY) \
	IMAGE_NAME=$(IMAGE_NAME) IMAGE_TAG=$(IMAGE_TAG) \
		goreleaser release

snapshot: # @HELP do dry run of goreleaser
	GITHUB_TOKEN=$(GITHUB_TOKEN) VERSION=$(VERSION) \
	REGISTRY=$(REGISTRY) \
	IMAGE_NAME=$(IMAGE_NAME) IMAGE_TAG=$(IMAGE_TAG) \
		goreleaser release --snapshot --clean

test: # @HELP run any tests
	go test ./...

lint: # @HELP lints project files and scripts
	sh ./build/scripts/lint.sh

clean: # @HELP cleans temporary files and build artifacts created during development
	REGISTRY=$(REGISTRY) DOCKER_IMAGE=$(IMAGE_NAME) ENVIRONMENT=docker-compose \
		docker compose down
	# Generated by goreleaser
	rm -rf dist

help: # @HELP prints this message
	@printf "===> HELP\n"
	@grep -hE '^.*: *# *@HELP' $(MAKEFILE_LIST) \
		| awk '									\
		BEGIN {FS = ": *# *@HELP"};				\
		{ printf "%-20s %s\n", $$1, $$2 }; '

help-config: # @HELP Makefile configuration 
	@printf "===> CONFIG\n"
	@grep -HE '^# *[A-Z_]+: ' $(MAKEFILE_LIST) \
		| sed -E 's|^([^:]+):# *([A-Z_]+): (.*)|  \2: \3  [\1]|'


version:
	@echo $(VERSION)

SHELL ?= /usr/bin/env bash -o errexit -o pipefail -o nounset
.DEFAULT_GOAL = all
.PHONY: all activate clean format help lint run test
