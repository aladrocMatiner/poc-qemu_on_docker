# OpenTofu + Libvirt Runbook

## Purpose
Provision and manage the Phase 1 lab using OpenTofu and libvirt.

## Prerequisites
- OpenTofu (`tofu`) installed
- libvirtd running
- Required host bridges exist (`SWARM_BRIDGE`, and `MGMT_BRIDGE` for bridge mode)

## Procedure
```bash
$ make tofu-init
$ make tofu-plan
$ make tofu-apply
```

## Inventory
Generate inventory from outputs:
```bash
$ make lab-status
```
This writes `work/inventory.json`.

## Troubleshooting
- If `virsh` cannot connect: verify `LIBVIRT_URI` and libvirtd service.
- If IP discovery fails: check DHCP leases for the management network.
