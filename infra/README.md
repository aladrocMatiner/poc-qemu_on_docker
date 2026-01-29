# OpenTofu Infra

This folder provisions Phase 1 lab VMs via libvirt using OpenTofu.

## Usage (via Make targets)
- `make tofu-init`
- `make tofu-plan`
- `make tofu-apply`
- `make tofu-destroy`

## Inputs
Values are provided via `.env` and exported as `TF_VAR_*` by `scripts/tofu/run.sh`.

Required inputs:
- `lab_name`, `lab_nodes`
- `vm_cpu`, `vm_ram_mb`, `vm_disk_gb`
- `mgmt_mode`, `mgmt_bridge`, `mgmt_network`
- `swarm_bridge`
- `mac_prefix`
- `ssh_user`, `ssh_pubkey_path`
- `base_image_name`, `downloads_dir`
- `pool_path`, `libvirt_uri`

## Outputs schema
`tofu output -json` provides:
- `lab_name`
- `mgmt_mode`
- `mgmt_network`
- `nodes[]`:
  - `index`
  - `name`
  - `mgmt_mac`
  - `swarm_mac`

This output is consumed by `scripts/tofu/inventory.sh` to build `work/inventory.json`.
