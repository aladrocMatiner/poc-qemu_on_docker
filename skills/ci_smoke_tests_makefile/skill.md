# ci_smoke_tests_makefile

## Goal
Provide Makefile-driven smoke tests to validate Swarm + VM basics.

## Non-goals
- Full integration test suite.
- Performance benchmarking.

## Prerequisites
- Swarm cluster running.
- Access to a manager node.

## Inputs/Variables (env vars, paths, configs)
- `STACK_NAME`
- `OVERLAY_NET_NAME`
- `BRIDGE=br0`
- `VM_MAC`
- `VM_NODE_LABEL=vm-capable=true`

## Steps (numbered procedure)
1. Create a `Makefile` target `smoke` to run checks.
2. Validate environment (Docker reachable, Swarm active).
3. Verify overlay network exists.
4. Verify `/dev/kvm` access on VM-capable nodes.
5. Start a sample VM runner stub and confirm it reaches DHCP.
6. Report pass/fail with clear output.
7. Outline a simple CI job to run `make smoke` on a staging cluster.

## Commands (short snippets)
```bash
$ docker info | grep -i swarm
$ docker network ls | grep ${OVERLAY_NET_NAME}
$ make smoke
```

## Security considerations
- Ensure smoke tests do not expose console ports.
- Avoid destructive operations in tests.

## Troubleshooting (symptom -> cause -> fix)
- Symptom: Smoke test fails on /dev/kvm check
  Cause: Device not present on node
  Fix: Verify virtualization and device permissions
- Symptom: Sample VM has no DHCP
  Cause: TAP/bridge misconfig or missing reservation
  Fix: Verify `br0` and DHCP entry

## Acceptance criteria (DoD)
- Smoke test completes successfully on a fresh node.
- Output clearly indicates pass/fail and next steps.

## Artifacts produced
- `Makefile` target or `scripts/smoke.sh`
- Smoke test documentation

## Related skills / docs
- `../swarm_cluster_bootstrap/skill.md`
- `../observability_logging_metrics/skill.md`
