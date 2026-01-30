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
- If QEMU reports `Permission denied` for disk images: AppArmor may be
  blocking access. Control this via `LIBVIRT_SECLABEL_MODE`:
  `auto` (default) enables the AppArmor seclabel only when libvirt reports
  it in `virsh domcapabilities`, `apparmor` forces it, and `none` disables it.
- If you see `Permission denied` on qcow2 files under your home directory,
  set `POOL_PATH` to a system directory like `/var/lib/libvirt/images/<lab>-pool`.
