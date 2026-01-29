# security_hardening_vm_services

## Goal
Apply least-privilege hardening to VM runner services in Swarm.

## Non-goals
- Full compliance program.
- Host kernel hardening.

## Prerequisites
- VM runner service definition exists.
- Seccomp/apparmor availability checked on hosts.

## Inputs/Variables (env vars, paths, configs)
- `CAPS_REQUIRED` (e.g., `NET_ADMIN` only if TAP created in container)
- `KVM_DEVICE=/dev/kvm`
- `SECCOMP_PROFILE`
- `APPARMOR_PROFILE`
- `CONSOLE_PORT_RANGE`

## Steps (numbered procedure)
1. Drop all capabilities and add back only what is needed.
2. Mount `/dev/kvm` as the only device; avoid other passthroughs.
3. Enable `no-new-privileges` and read-only rootfs where possible.
4. Apply seccomp/apparmor profiles or document exceptions.
5. Restrict console exposure and document publish mode.
6. Use Swarm secrets/configs for sensitive data.

## Commands (short snippets)
```yaml
services:
  vm-runner:
    cap_drop: ["ALL"]
    cap_add: ["NET_ADMIN"]
    devices: ["/dev/kvm:/dev/kvm"]
    security_opt:
      - no-new-privileges:true
    read_only: true
```

## Security considerations
- Pre-create TAP devices on host to avoid `CAP_NET_ADMIN`.
- Do not expose console ports publicly.
- Never store secrets in env vars or git.

## Troubleshooting (symptom -> cause -> fix)
- Symptom: QEMU cannot open `/dev/kvm`
  Cause: Device not mounted or permissions
  Fix: Bind-mount `/dev/kvm` and verify group membership
- Symptom: TAP creation fails
  Cause: Missing `CAP_NET_ADMIN`
  Fix: Pre-create TAP on host or add minimal cap

## Acceptance criteria (DoD)
- VM runners operate with minimal caps and no `--privileged`.
- Security profiles documented and applied.

## Artifacts produced
- Hardened service definitions
- Security profile references

## Related skills / docs
- `../qemu_kvm_in_container/skill.md`
- `../../agents/secops/agent.md`
