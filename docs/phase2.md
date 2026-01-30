# Phase 2: QEMU-in-Container on Swarm

## Goal
Demonstrate that a Swarm cluster can run normal container services and VM runner services (QEMU/KVM) side-by-side, first with Linux and then with Windows.

## Demos / Cases

### Case 00: Vanilla services (two normal containers)
- Purpose: prove Swarm can run two normal services on different nodes and they can ping each other over the same overlay network.
- Stack: `stacks/phase2-linux-demo.yml`
- Ansible:
```bash
make ansible-swarm-poc-qemu-case00-up
make ansible-swarm-poc-qemu-case00-down
make ansible-swarm-poc-qemu-case00-test
make ansible-swarm-poc-qemu-case00-exec-list
make ansible-swarm-poc-qemu-case00-exec <container_name>
```
Required labels (one node each):
```bash
case00 placement is now automatic (random distinct nodes) during case00 up.
```

### Case 01: Linux VM runner (usable pipeline)
- Purpose: reproducible Linux VM runner with deterministic MAC/IP and validation.
- Stack: `stacks/phase2-linux-usable.yml`
- Ansible:
```bash
make ansible-swarm-poc-qemu-case01-up
make ansible-swarm-poc-qemu-case01-down
```

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
