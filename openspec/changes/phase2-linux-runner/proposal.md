## Why

We need a proof that a Swarm service can run a Linux VM inside a container and expose that VM on a real L2 segment (same subnet) so other Swarm services can reach it directly by IP/ports, not via NAT or host-only access.

## What Changes

- Define a Phase 2 Linux VM runner that attaches the guest NIC to a real L2 network (br0) with deterministic MAC and DHCP reservation.
- Add a Swarm-friendly deployment pattern for the VM runner service (no `--privileged`) with explicit capabilities and device mounts where required.
- Provide Ansible-run test flow to create, verify, and tear down the Linux VM runner service and confirm L2 connectivity with normal Swarm services.

## Capabilities

### New Capabilities
- `vm-runner-linux-service`: Run a Linux VM inside a Swarm service container using QEMU with a deterministic MAC, reproducible images, and console/SSH access.
- `vm-runner-l2-networking`: Connect the Linux VM NIC to a real L2 segment (br0) so it receives a DHCP lease by MAC and is reachable from other Swarm services.
- `phase2-case01-linux-demo`: Ansible-driven demo that deploys two normal services plus the Linux VM runner and verifies L2 connectivity between all three.

### Modified Capabilities
- (none)

## Impact

- New/updated Ansible roles and playbooks for VM runner provisioning and validation.
- Swarm stack/service definitions for the Linux VM runner with L2 networking requirements.
- Documentation and runbooks covering L2 mode assumptions, DHCP reservations, and troubleshooting.
- Inventory schema and tests extended to include VM runner and guest IP reporting.
