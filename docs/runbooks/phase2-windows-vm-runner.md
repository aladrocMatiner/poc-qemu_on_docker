# Phase 2 Windows VM Runner

## Purpose
Run a Windows VM inside a Swarm VM runner service and validate via Ansible.

## Prerequisites
- Swarm cluster healthy
- Nodes labeled `vm-capable=true`
- `/dev/kvm` available on VM runner nodes
- Windows ISO and virtio ISO paths configured (not committed)

## Procedure
```bash
make ansible-swarm-poc-qemu-windows
```

Optional: provide VM IPs for validation checks:
```bash
vm_windows_ips='["192.168.123.60"]' make ansible-swarm-poc-qemu-windows
```

## Troubleshooting
- VM not reachable: verify ISO paths and VM runner logs.
- RDP/WinRM timeout: check firewall and WinRM configuration.
- Service not scheduled: verify node labels and constraints.

## Rollback
```bash
docker stack rm phase2-windows-vm
```
