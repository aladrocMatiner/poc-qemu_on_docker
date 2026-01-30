# Phase 2 Linux VM Runner

## Purpose
Run a Linux VM inside a Swarm VM runner service and validate via Ansible.

## Prerequisites
- Swarm cluster healthy
- Nodes labeled `vm-capable=true`
- `/dev/kvm` available on VM runner nodes
- `LIBVIRT_CPU_MODE=host-passthrough` in `.env` (nested KVM in lab VMs)
- DHCP reservations by MAC on the L2 network

## Procedure
```bash
make ansible-swarm-poc-qemu-linux
```

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
