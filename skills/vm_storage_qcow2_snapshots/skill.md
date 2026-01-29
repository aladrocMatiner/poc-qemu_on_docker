# vm_storage_qcow2_snapshots

## Goal
Manage qcow2 images, backing files, and snapshots safely.

## Non-goals
- Distributed replication or HA storage.
- Automated backup pipelines.

## Prerequisites
- `qemu-img` available.
- Base images stored outside git.

## Inputs/Variables (env vars, paths, configs)
- `BASE_IMAGE`
- `INSTANCE_DISK`
- `SNAPSHOT_NAME`
- `STORAGE_ROOT=/var/lib/poc-qemu`

## Steps (numbered procedure)
1. Store base images in `${STORAGE_ROOT}/images` (read-only).
2. Create per-VM overlays in `${STORAGE_ROOT}/instances`.
3. Use internal snapshots for short-term checkpoints only.
4. Compact images with `qemu-img convert` during maintenance windows.
5. Ensure VMs are cleanly shut down before snapshot/compaction.
6. Document backend type (local vs NFS) and constraints.

## Commands (short snippets)
```bash
$ qemu-img create -f qcow2 -b ${BASE_IMAGE} ${INSTANCE_DISK}
$ qemu-img snapshot -c ${SNAPSHOT_NAME} ${INSTANCE_DISK}
$ qemu-img check ${INSTANCE_DISK}
```

## Security considerations
- Restrict permissions on image directories.
- Avoid storing sensitive data in base images.

## Troubleshooting (symptom -> cause -> fix)
- Symptom: Image corruption detected
  Cause: Snapshot/compaction while VM running
  Fix: Shut down VM and run `qemu-img check`
- Symptom: Backing file missing
  Cause: Base image moved
  Fix: Restore base image path or rebase

## Acceptance criteria (DoD)
- VM disks stored under defined layout.
- Snapshots created only when VM is stopped.
- `qemu-img check` passes before reuse.

## Artifacts produced
- qcow2 base and overlay images
- Snapshot records

## Related specs / docs
- Spec ID: `vm-storage-qcow2` (see `../../specs/index.yaml`)
- Runbooks: `docs/runbooks/TBD`
- ADRs: `docs/adr/TBD`
