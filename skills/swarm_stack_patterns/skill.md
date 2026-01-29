# swarm_stack_patterns

## Goal
Deploy Swarm stacks consistently with secrets/configs, placement constraints, and safe update/rollback behavior.

## Non-goals
- Full CI/CD pipeline implementation.
- Multi-tenant authorization policies.

## Prerequisites
- Swarm initialized and nodes joined.
- Overlay network(s) created and available.

## Inputs/Variables (env vars, paths, configs)
- `STACK_NAME`
- `COMPOSE_FILE` (Compose v3+)
- `OVERLAY_NET_NAME`
- `NODE_LABELS` (e.g., `vm-capable=true`)

## Steps (numbered procedure)
1. Define services with `deploy` constraints, resources, and restart policies.
2. Use Swarm `secrets` and `configs` (avoid env files for secrets).
3. Choose `endpoint_mode` (VIP or DNSRR) based on service type.
4. Configure `update_config` and `rollback_config` for safe rollouts.
5. Deploy stack and verify service placement.

## Commands (short snippets)
```bash
$ docker stack deploy -c ${COMPOSE_FILE} ${STACK_NAME}
$ docker stack services ${STACK_NAME}
$ docker service ps ${STACK_NAME}_<service>
```

**Normal container service (conceptual)**
```yaml
services:
  api:
    image: example/api:latest
    networks: [internal-net]
    deploy:
      replicas: 2
      endpoint_mode: vip
      update_config:
        order: start-first
      rollback_config:
        order: stop-first
```

**VM runner service (conceptual)**
```yaml
services:
  vm-runner:
    image: example/qemu-runner:latest
    devices: ["/dev/kvm:/dev/kvm"]
    volumes:
      - /var/lib/poc-qemu:/var/lib/poc-qemu
    deploy:
      placement:
        constraints: ["node.labels.vm-capable==true"]
      resources:
        reservations:
          memory: 4G
```

## Security considerations
- Do not embed secrets in environment variables.
- Use minimal capabilities and avoid `--privileged`.
- Document any `CAP_NET_ADMIN` usage for TAP.

## Troubleshooting (symptom -> cause -> fix)
- Symptom: Task scheduled on wrong node
  Cause: Missing or incorrect constraint
  Fix: Verify node labels and `deploy.placement.constraints`
- Symptom: Service update causes downtime
  Cause: Update strategy not set
  Fix: Use `update_config` with `start-first`

## Acceptance criteria (DoD)
- Stack deploys cleanly and services are placed as intended.
- Secrets/configs are referenced correctly.
- Update/rollback behavior documented.

## Artifacts produced
- Stack Compose file
- Service placement rules

## Related specs / docs
- Spec ID: `swarm-stack-patterns` (see `../../specs/index.yaml`)
- Runbooks: `docs/runbooks/TBD`
- ADRs: `docs/adr/TBD`
