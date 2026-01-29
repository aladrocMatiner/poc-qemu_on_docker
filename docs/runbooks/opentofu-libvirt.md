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
- If IP discovery fails: check DHCP leases for the management network. For fixed IPs, set `MGMT_NETWORK_CIDR` and `MGMT_IP_START` in `.env`.
- If QEMU reports `Permission denied` for disk images: AppArmor is likely
  blocking access. The lab domains inject a `seclabel` to disable AppArmor
  (`infra/modules/swarm_lab/domain-seclabel-none.xslt`).
