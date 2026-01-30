# Phase 2 Linux VM Runner

## Purpose
Run a Linux VM inside a Swarm VM runner service and validate via Ansible.

## Prerequisites
- Swarm cluster healthy
- Nodes labeled `vm-capable=true`
- `/dev/kvm` available on VM runner nodes
- `LIBVIRT_CPU_MODE=host-passthrough` in `.env` (nested KVM in lab VMs)
- DHCP reservations by MAC on the L2 network
- VM runner assets present on all nodes:
  - `/var/lib/vmrunner/images/linux.qcow2`
  - `/var/lib/vmrunner/seeds/linux-seed.iso`
  - `/var/lib/vmrunner/keys/id_ed25519` (private key for VM SSH)
- VM runner image built on each node from `images/vm-runner-linux/`.

## Procedure
```bash
make ansible-swarm-poc-qemu-linux
```

This will prepare VM runner assets on all nodes (keys, base image, qcow2, seed) if missing.

Optional: provide VM IPs for validation checks:
```bash
vm_linux_ips='["192.168.123.50"]' make ansible-swarm-poc-qemu-linux
```

## Troubleshooting
- VM not reachable: verify TAP/bridge wiring and DHCP reservations.
- SSH timeout: ensure VM is booted and SSH enabled.
- Service not scheduled: verify node labels and constraints.

## Rollback
```bash
docker stack rm phase2-linux-usable
```
