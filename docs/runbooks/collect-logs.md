# Collect Logs

## Purpose
Capture diagnostic artifacts after a failed lab run.

## Command
```bash
$ make collect-logs
```

## Contents
- `work/inventory.json`
- `work/tofu-outputs.json`
- `virsh list` output and domain XMLs
- cloud-init logs (best-effort)
- ansible logs (best-effort)

## Notes
- SSH access is required for remote log capture.
- No secrets are collected by default.
