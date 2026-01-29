SHELL := /bin/bash

ifneq ("$(wildcard .env)","")
include .env
export
else
$(warning .env not found. Copy .env.example to .env and edit.)
endif

.PHONY: bootstrap prereqs-check

bootstrap:
	@./scripts/prereqs/bootstrap.sh

prereqs-check:
	@./scripts/tools/check.sh
