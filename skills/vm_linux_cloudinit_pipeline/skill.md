# vm_linux_cloudinit_pipeline

## Goal
Provision Linux VMs with cloud-init using qcow2 images and seed ISOs.

## Non-goals
- Full image factory or CI pipeline.
- Embedding secrets in user-data.

## Prerequisites
- Base cloud image available (Ubuntu/Debian/RHEL variants).
- `cloud-localds` or equivalent installed.

## Inputs/Variables (env vars, paths, configs)
- `BASE_IMAGE` (qcow2)
- `INSTANCE_DISK`
- `USER_DATA` / `META_DATA`
- `SEED_ISO`
- `SSH_PUBLIC_KEY`
- Recommended layout: `/var/lib/poc-qemu/{images,instances,seeds,isos}`

## Steps (numbered procedure)
1. Create a qcow2 overlay from the base image.
2. Create cloud-init user-data/meta-data (inject SSH key).
3. Build a seed ISO and attach it as a CD-ROM.
4. Boot the VM and verify cloud-init completion.
5. Confirm DHCP reservation and SSH access.

## Commands (short snippets)
```bash
$ qemu-img create -f qcow2 -b ${BASE_IMAGE} ${INSTANCE_DISK}
$ cloud-localds ${SEED_ISO} ${USER_DATA} ${META_DATA}
```

## Security considerations
- Do not store passwords or secrets in user-data.
- Use SSH keys and rotate as needed.

## Troubleshooting (symptom -> cause -> fix)
- Symptom: cloud-init not running
  Cause: Seed ISO missing or wrong datasource
  Fix: Attach seed ISO and use NoCloud datasource
- Symptom: SSH key not applied
  Cause: User-data syntax error
  Fix: Validate YAML and rebuild seed ISO

## Acceptance criteria (DoD)
- VM boots and applies cloud-init configuration.
- SSH access works with injected key.

## Artifacts produced
- qcow2 overlay disk
- cloud-init seed ISO

## Related specs / docs
- Spec ID: `vm-linux-cloudinit` (see `../../specs/index.yaml`)
- Runbooks: `docs/runbooks/TBD`
- ADRs: `docs/adr/TBD`
