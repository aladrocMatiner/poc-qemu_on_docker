# qemu_kvm_in_container

## Goal
Run QEMU/KVM inside a Swarm service without `--privileged`, using `/dev/kvm` and minimal capabilities.

## Non-goals
- GPU/PCI passthrough or SR-IOV.
- Full performance tuning or production hardening.

## Prerequisites
- CPU virtualization enabled (VT-x/AMD-V).
- `/dev/kvm` present on VM-capable nodes.
- Base image registry accessible to Swarm.

## Inputs/Variables (env vars, paths, configs)
- `VM_NAME`
- `IMAGE_PATH` (qcow2)
- `ISO_PATH` (external, not in git)
- `OVMF_CODE` / `OVMF_VARS` paths
- `KVM_DEVICE=/dev/kvm`
- `TUN_DEVICE=/dev/net/tun` (optional if TAP created in-container)

## Steps (numbered procedure)
1. Build a VM runner image with required packages (qemu-system-x86, ovmf, qemu-utils, iproute2).
2. Mount `/dev/kvm` into the service container.
3. Optionally mount `/dev/net/tun` only if TAP is created in-container (prefer host-side TAP).
4. Mount VM storage paths from `/var/lib/poc-qemu` (images, isos, logs).
5. Apply Swarm constraints to place on `vm-capable=true` nodes.
6. Set resource reservations/limits for CPU and RAM.
7. Start QEMU with `-enable-kvm` and verify acceleration.

## Commands (short snippets)
```bash
# Example Dockerfile packages (Debian/Ubuntu)
# qemu-system-x86 ovmf qemu-utils iproute2

# Swarm service snippet (conceptual)
services:
  vm-runner:
    devices:
      - /dev/kvm:/dev/kvm
    volumes:
      - /var/lib/poc-qemu:/var/lib/poc-qemu
    deploy:
      placement:
        constraints: ["node.labels.vm-capable==true"]
      resources:
        reservations:
          memory: 4G
        limits:
          memory: 6G
```

## Security considerations
- Drop all caps by default; add only if strictly required.
- Prefer host-precreated TAP to avoid `CAP_NET_ADMIN`.
- Use `no-new-privileges` and read-only rootfs where possible.

## Troubleshooting (symptom -> cause -> fix)
- Symptom: `KVM not supported` in logs
  Cause: `/dev/kvm` missing or VT-x/AMD-V disabled
  Fix: Bind-mount `/dev/kvm` and enable virtualization in BIOS/UEFI
- Symptom: QEMU cannot access disk
  Cause: Incorrect volume mount or permissions
  Fix: Verify host path and container user/group

## Acceptance criteria (DoD)
- VM boots with `-enable-kvm` and no `--privileged` usage.
- Service placed only on `vm-capable=true` nodes.

## Artifacts produced
- VM runner container image
- Swarm service definition

## Related skills / docs
- `../qemu_tap_bridge_networking/skill.md`
- `../security_hardening_vm_services/skill.md`
- `../swarm_node_constraints_resources/skill.md`
