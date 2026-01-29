# observability_logging_metrics

## Goal
Provide baseline logging and metrics for Swarm services and VM runners.

## Non-goals
- Full SIEM integration or distributed tracing.
- Advanced alerting pipelines.

## Prerequisites
- Swarm cluster running.
- Access to manager node for stack deploy.

## Inputs/Variables (env vars, paths, configs)
- `LOG_PATH=/var/lib/poc-qemu/logs`
- `NODE_EXPORTER_PORT=9100`
- `CADVISOR_PORT=8080`
- `STACK_NAME=monitoring`

## Steps (numbered procedure)
1. Persist VM runner logs to host volume `${LOG_PATH}`.
2. Deploy node-exporter and cAdvisor as global services.
3. Expose metrics on internal networks only.
4. Define minimal dashboards (CPU, RAM, disk, network, VM uptime).
5. Add basic alerts: node down, disk full, high CPU.

## Commands (short snippets)
```bash
$ docker service logs <vm-runner>
$ curl http://<node-ip>:9100/metrics
$ curl http://<node-ip>:8080/metrics
```

## Security considerations
- Restrict metrics endpoints to trusted networks.
- Avoid logging sensitive data or secrets.

## Troubleshooting (symptom -> cause -> fix)
- Symptom: Missing VM logs
  Cause: Log volume not mounted
  Fix: Mount `${LOG_PATH}` into the VM runner
- Symptom: Metrics endpoint unreachable
  Cause: Port blocked or service not running
  Fix: Open port and verify service status

## Acceptance criteria (DoD)
- VM runner logs available on host.
- Node-exporter and cAdvisor reachable from monitoring host.
- Basic dashboards/alerts documented.

## Artifacts produced
- Monitoring stack definition
- Log volume mappings

## Related skills / docs
- `../swarm_stack_patterns/skill.md`
- `../ci_smoke_tests_makefile/skill.md`
