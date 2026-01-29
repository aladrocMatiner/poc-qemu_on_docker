# swarm_node_constraints_resources

## Goal
Place VM runners on capable nodes using labels and resource reservations/limits.

## Non-goals
- Autoscaling or dynamic capacity management.
- NUMA pinning or CPU isolation.

## Prerequisites
- Swarm initialized and nodes joined.
- Hardware inventory available.

## Inputs/Variables (env vars, paths, configs)
- `VM_LABEL=vm-capable=true`
- `CPU_RESERVATION` / `CPU_LIMIT`
- `MEM_RESERVATION` / `MEM_LIMIT`

## Steps (numbered procedure)
1. Label nodes with `vm-capable=true` and optional storage labels.
2. Add placement constraints to VM runner services.
3. Set resource reservations and limits to prevent overcommit.
4. Optionally isolate VM workloads on dedicated nodes.
5. Verify scheduling and task placement.

## Commands (short snippets)
```bash
$ docker node update --label-add vm-capable=true <node-id>
$ docker node inspect <node-id> --format '{{.Spec.Labels}}'
$ docker service ps <stack>_vm-runner
```

## Security considerations
- Prevent resource starvation that could destabilize hosts.
- Document any exceptions to placement rules.

## Troubleshooting (symptom -> cause -> fix)
- Symptom: VM runner not scheduled
  Cause: No nodes match constraint
  Fix: Verify labels or relax constraints

## Acceptance criteria (DoD)
- VM runner tasks scheduled only on labeled nodes.
- Resource reservations documented and applied.

## Artifacts produced
- Node labels
- Placement constraints in stack files

## Related specs / docs
- Spec ID: `swarm-node-constraints` (see `../../specs/index.yaml`)
- Runbooks: `docs/runbooks/TBD`
- ADRs: `docs/adr/TBD`
