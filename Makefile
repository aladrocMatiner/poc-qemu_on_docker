SHELL := /bin/bash

ifneq ("$(wildcard .env)","")
include .env
export
else
$(warning .env not found. Copy .env.example to .env and edit.)
endif

.PHONY: bootstrap prereqs-check \
	tofu-init tofu-fmt tofu-validate tofu-plan tofu-apply tofu-destroy tofu-output \
	lab-init lab-up lab-destroy lab-status lab-console lab-ssh \
	ansible-bootstrap ansible-inventory ansible-ping ansible-baseline ansible-docker ansible-swarm ansible-verify ansible-swarm-status ansible-run \
	ansible-swarm-poc-qemu-demo ansible-swarm-poc-qemu-linux ansible-swarm-poc-qemu-windows \
	ansible-all \
	smoke smoke-idempotent test-matrix \
	image-fetch image-verify image-info image-clean \
	host-network-setup collect-logs \
	doctor clean reset lab-snapshot lab-restore

bootstrap:
	@./scripts/prereqs/bootstrap.sh

prereqs-check:
	@./scripts/tools/check.sh

tofu-init:
	@./scripts/tofu/run.sh init

tofu-fmt:
	@./scripts/tofu/run.sh fmt

tofu-validate:
	@./scripts/tofu/run.sh validate

tofu-plan:
	@./scripts/tofu/run.sh plan

tofu-apply:
	@./scripts/tofu/run.sh apply

tofu-destroy:
	@./scripts/tofu/run.sh destroy

tofu-output:
	@./scripts/tofu/run.sh output

lab-init: prereqs-check tofu-init

image-fetch:
	@./scripts/images/fetch.sh

image-verify:
	@./scripts/images/verify.sh

image-info:
	@./scripts/images/info.sh

image-clean:
	@./scripts/images/clean.sh

lab-up: tofu-apply

lab-destroy:
	@./scripts/lab/destroy.sh

lab-status: tofu-output
	@./scripts/tofu/inventory.sh

lab-console:
	@./scripts/lab/console.sh

lab-ssh:
	@./scripts/lab/ssh.sh

ansible-bootstrap:
	@./scripts/ansible/galaxy_install.sh

ansible-inventory:
	@./scripts/ansible/inventory.sh

ansible-ping:
	@./scripts/ansible/ping.sh

ansible-baseline:
	@./scripts/ansible/run.sh ansible/playbooks/baseline.yml

ansible-docker:
	@./scripts/ansible/run.sh ansible/playbooks/docker.yml

ansible-swarm:
	@./scripts/ansible/run.sh ansible/playbooks/swarm.yml

ansible-verify:
	@./scripts/ansible/run.sh ansible/playbooks/verify.yml

ansible-swarm-status:
	@./scripts/ansible/run.sh ansible/playbooks/swarm_status.yml

ansible-swarm-poc-qemu-demo:
	@./scripts/ansible/run.sh ansible/anisble-poc_qemu/phase2_linux_demo.yml

ansible-swarm-poc-qemu-linux:
	@./scripts/ansible/run.sh ansible/anisble-poc_qemu/phase2_linux_usable.yml

ansible-swarm-poc-qemu-windows:
	@./scripts/ansible/run.sh ansible/anisble-poc_qemu/phase2_windows_vm.yml

ansible-all: lab-status ansible-bootstrap ansible-inventory ansible-ping ansible-baseline ansible-docker ansible-swarm ansible-verify

ansible-run:
	@./scripts/ansible/run.sh $(PLAYBOOK)

host-network-setup:
	@./scripts/host/network_setup.sh

collect-logs:
	@./scripts/diag/collect_logs.sh

doctor:
	@./scripts/tools/check.sh
	@$(MAKE) tofu-validate
	@if [ -f work/inventory.json ] || [ -f work/tofu-outputs.json ]; then \
		$(MAKE) lab-status || true; \
	else \
		echo "No lab state detected; skipping inventory check"; \
	fi
	@if [ -f ansible/inventories/generated/inventory.ini ]; then \
		$(MAKE) ansible-ping || true; \
	else \
		echo "Ansible inventory missing; run make ansible-inventory"; \
	fi

clean:
	@rm -rf work/logs work/artifacts work/inventory.json work/tofu-outputs.json ansible/inventories/generated/inventory.ini
	@echo "Cleaned local artifacts (VMs untouched)."

reset: lab-destroy clean

lab-snapshot:
	@if [ -z "$(NAME)" ]; then echo "NAME is required: make lab-snapshot NAME=foo"; exit 1; fi
	@echo "Best-effort snapshot for lab domains (limitations may apply)."
	@for dom in $$(virsh list --all --name | grep "^$(LAB_NAME)-" || true); do \
		virsh snapshot-create-as --domain $$dom --name $(NAME) --description "lab snapshot $(NAME)" || true; \
	done

lab-restore:
	@if [ -z "$(NAME)" ]; then echo "NAME is required: make lab-restore NAME=foo"; exit 1; fi
	@echo "Best-effort snapshot restore for lab domains (limitations may apply)."
	@for dom in $$(virsh list --all --name | grep "^$(LAB_NAME)-" || true); do \
		virsh snapshot-revert --domain $$dom --snapshotname $(NAME) --running || true; \
	done

smoke:
	@$(MAKE) bootstrap
	@$(MAKE) lab-up
	@$(MAKE) lab-status
	@$(MAKE) ansible-inventory
	@$(MAKE) ansible-baseline ansible-docker ansible-swarm
	@$(MAKE) ansible-verify
	@$(MAKE) lab-destroy

smoke-idempotent:
	@$(MAKE) lab-up
	@$(MAKE) lab-status
	@$(MAKE) ansible-inventory
	@$(MAKE) ansible-baseline ansible-docker ansible-swarm
	@$(MAKE) ansible-verify

test-matrix:
	@$(MAKE) smoke MGMT_MODE=user
	@if [ -n "$(MGMT_BRIDGE)" ]; then \
		$(MAKE) smoke MGMT_MODE=bridge; \
	else \
		echo "MGMT_BRIDGE not set; skipping MGMT_MODE=bridge"; \
	fi
