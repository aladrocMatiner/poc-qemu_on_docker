# Phase 2: QEMU-in-Container on Swarm

## Goal
Demonstrate that a Swarm cluster can run normal container services and VM runner services (QEMU/KVM) side-by-side, first with Linux and then with Windows.

## Demos / Cases

### Case 00: Vanilla services (two normal containers)
- Purpose: validate overlay networking between two normal Swarm services placed on different nodes.
- Stack: `stacks/phase2-linux-demo.yml`
- Ansible:
```bash
make ansible-swarm-poc-qemu-case00-up
make ansible-swarm-poc-qemu-case00-down
make ansible-swarm-poc-qemu-case00-test
make ansible-swarm-poc-qemu-case00-exec-list
make ansible-swarm-poc-qemu-case00-exec <container_name>
```
Notes:
- Placement is automatic (random distinct nodes) during case00 up.
- `case00-test` checks ping and HTTP between services on the overlay network.
- `case00-exec-list` prints: CONTAINER, NODE, overlay IP, SERVICE (one per line).
- `case00-exec` opens a shell in the selected container.

### Case 01: Linux VM runner (usable pipeline)
- Purpose: same base overlay validation as Case 00, plus a Linux VM runner service in the stack.
- Stack: `stacks/phase2-linux-usable.yml`
- Ansible:
```bash
make ansible-swarm-poc-qemu-case01-up
make ansible-swarm-poc-qemu-case01-test
make ansible-swarm-poc-qemu-case01-exec-list
make ansible-swarm-poc-qemu-case01-exec <container_name>
make ansible-swarm-poc-qemu-case01-down
```
Notes:
- `case01-test` reuses the same connectivity checks as Case 00 against the normal services.
- `case01-exec-list` and `case01-exec` work the same as Case 00 for service containers.
- VM connectivity check uses SSH inside the vm-runner container to reach the guest via `127.0.0.1:2222`.
- Provide a private key at `/var/lib/vmrunner/keys/id_ed25519` on the host (mounted to `/vm/keys` in the container).
- `make ansible-swarm` auto-labels nodes `vm-capable=true` if `/dev/kvm` exists.

### Case 02: Windows VM runner
- Purpose: Windows VM runner with external ISO/virtio and access validation.
- Stack: `stacks/phase2-windows-vm.yml`
- Ansible:
```bash
make ansible-swarm-poc-qemu-case02-up
make ansible-swarm-poc-qemu-case02-down
```

## Notes
- VM runner services must avoid `--privileged` and use `/dev/kvm` + minimal caps.
- DHCP reservations are based on deterministic MACs.
- All validation is executed via Ansible.
