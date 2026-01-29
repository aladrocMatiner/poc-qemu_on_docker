# vm_windows_unattended_virtio

## Goal
Provision Windows VMs unattended with virtio drivers and UEFI boot.

## Non-goals
- Embedding product keys in the repo.
- GUI-based manual installs.

## Prerequisites
- Windows ISO available (external path, not in git).
- Virtio driver ISO available.
- `autounattend.xml` prepared.

## Inputs/Variables (env vars, paths, configs)
- `WIN_ISO_PATH`
- `VIRTIO_ISO_PATH`
- `AUTOUNATTEND_PATH`
- `INSTANCE_DISK`
- `OVMF_CODE` / `OVMF_VARS`

## Steps (numbered procedure)
1. Create qcow2 disk for the Windows VM.
2. Attach Windows ISO and virtio ISO.
3. Boot with OVMF (UEFI) unless BIOS is required for legacy images.
4. Ensure virtio drivers are loaded for disk and NIC.
5. Validate post-install access via RDP or WinRM.

## Commands (short snippets)
```bash
$ qemu-img create -f qcow2 ${INSTANCE_DISK} 60G
$ qemu-system-x86_64 -enable-kvm -m 4096 -smp 2 \
  -drive file=${INSTANCE_DISK},if=virtio \
  -cdrom ${WIN_ISO_PATH} -drive file=${VIRTIO_ISO_PATH},media=cdrom \
  -drive if=pflash,format=raw,readonly=on,file=${OVMF_CODE} \
  -drive if=pflash,format=raw,file=${OVMF_VARS}
```

## Security considerations
- Never store Windows keys or admin passwords in git.
- Restrict RDP exposure (host firewall or SSH tunnel).

## Troubleshooting (symptom -> cause -> fix)
- Symptom: Installer cannot see disk
  Cause: Missing virtio storage driver
  Fix: Load driver from virtio ISO
- Symptom: No network after install
  Cause: Virtio NIC driver missing
  Fix: Install virtio-net driver from ISO

## Acceptance criteria (DoD)
- Windows installs unattended and boots cleanly.
- VM obtains DHCP lease via MAC reservation.
- RDP or WinRM reachable from trusted network.

## Artifacts produced
- qcow2 disk image
- `autounattend.xml` (stored outside secrets)

## Related skills / docs
- `../vm_console_access_vnc_spice_rdp/skill.md`
- `../dhcp_dns_reservations/skill.md`
