# Network Modes (MGMT_MODE)

## Overview
The lab supports two management access modes. The swarm NIC always attaches to `SWARM_BRIDGE` for L2 LAN connectivity.

### MGMT_MODE=user (default)
- Uses libvirt NAT network (default: `default`).
- Management IPs are discovered via `virsh net-dhcp-leases`.
- If `MGMT_NETWORK_CIDR` is set, the lab creates/manages the network and reserves fixed IPs starting at `MGMT_IP_START`.
  Use a non-default `MGMT_NETWORK` name when enabling this.
- Safer and requires no host bridge changes.

### MGMT_MODE=bridge
- Management NIC attaches to `MGMT_BRIDGE` (host bridge).
- Requires the bridge to exist and have DHCP or static IP plan.
- More realistic but depends on host network setup.

## Required host setup
- `SWARM_BRIDGE` must exist in all modes.
- `MGMT_BRIDGE` must exist for MGMT_MODE=bridge.

## Access behavior
- user mode: SSH uses discovered DHCP lease IPs (or reserved IPs when `MGMT_NETWORK_CIDR` is set).
- bridge mode: SSH uses DHCP lease IPs if discoverable; otherwise set `NODE_MGMT_IP_NODE<N>` in `.env`.

## Troubleshooting
- Missing IP: check `virsh net-dhcp-leases <MGMT_NETWORK>` and MAC matching.
- Bridge missing: create host bridge explicitly (see host network setup runbook).
- ARP/DHCP issues: verify bridge MTU and L2 reachability.
