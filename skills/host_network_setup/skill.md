# host_network_setup

## Goal
Create required host bridges (`SWARM_BRIDGE`, optionally `MGMT_BRIDGE`) on demand using an explicit, opt-in helper.

## Non-goals
- Automatically modifying existing host networking.
- Attaching physical NICs or assigning IPs.

## Prerequisites
- Root or sudo access on the host.
- iproute2 installed.

## Inputs/Variables (.env vars)
- `SWARM_BRIDGE`
- `MGMT_BRIDGE` (optional)
- `HOST_NETWORK_ASSUME_YES=1`

## Steps
1. Set `HOST_NETWORK_ASSUME_YES=1` to explicitly opt in.
2. Run `make host-network-setup`.
3. Verify bridges exist with `ip link show`.

## Commands
```bash
$ HOST_NETWORK_ASSUME_YES=1 make host-network-setup
$ ip link show br0
```

## Security considerations
- Bridge creation affects host networking; use least privilege.
- Do not run without explicit confirmation.

## Troubleshooting (symptom -> cause -> fix)
- Symptom: Script refuses to run
  Cause: `HOST_NETWORK_ASSUME_YES` not set
  Fix: `HOST_NETWORK_ASSUME_YES=1 make host-network-setup`
- Symptom: Bridge missing
  Cause: Insufficient privileges
  Fix: Run with sudo or ensure user has permissions

## Acceptance criteria (DoD)
- Requested bridges exist and are up.
- Rollback steps documented.

## Artifacts produced
- `scripts/host/network_setup.sh`

## Related specs / docs
- Spec ID: `host-network-setup` (see `../../specs/index.yaml`)
- Runbooks: `docs/runbooks/network-modes.md`
- ADRs: `docs/adr/TBD`
