#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ROOT_DIR=$(cd "${SCRIPT_DIR}/../.." && pwd)

# shellcheck disable=SC1091
. "${ROOT_DIR}/scripts/lib/env.sh"
load_env

INFRA_DIR=${INFRA_DIR:-infra}
TOFU_BIN=${TOFU_BIN:-tofu}
TOFU_STATE_DIR=${TOFU_STATE_DIR:-work/tofu-state}
WORKDIR=${WORKDIR:-work}
DOWNLOADS_DIR=${DOWNLOADS_DIR:-work/downloads}
POOL_PATH=${POOL_PATH:-/var/lib/libvirt/images/${LAB_NAME:-swarm-lab}-pool}

maybe_reexec_with_libvirt_group "$@"

abs_path() {
  local path=$1
  if [[ "${path}" = /* ]]; then
    printf "%s" "${path}"
  else
    printf "%s" "$(realpath -m "${ROOT_DIR}/${path}")"
  fi
}

DOWNLOADS_DIR=$(abs_path "${DOWNLOADS_DIR}")
POOL_PATH=$(abs_path "${POOL_PATH}")
ensure_libvirt_pool_permissions "${POOL_PATH}"

cd "${ROOT_DIR}"
mkdir -p "${TOFU_STATE_DIR}"
export TF_DATA_DIR="${TOFU_STATE_DIR}"

export TF_VAR_lab_name="${LAB_NAME:-swarm-lab}"
export TF_VAR_lab_nodes="${LAB_NODES:-4}"
export TF_VAR_vm_cpu="${VM_CPU:-2}"
export TF_VAR_vm_ram_mb="${VM_RAM_MB:-4096}"
export TF_VAR_vm_disk_gb="${VM_DISK_GB:-20}"
export TF_VAR_mgmt_mode="${MGMT_MODE:-user}"
export TF_VAR_mgmt_bridge="${MGMT_BRIDGE:-}"
export TF_VAR_mgmt_network="${MGMT_NETWORK:-default}"
export TF_VAR_mgmt_network_cidr="${MGMT_NETWORK_CIDR:-}"
export TF_VAR_mgmt_ip_start="${MGMT_IP_START:-10}"
export TF_VAR_swarm_bridge="${SWARM_BRIDGE:-br0}"
export TF_VAR_mac_prefix="${MAC_PREFIX:-52:54:00:ab:cd}"
export TF_VAR_ssh_user="${SSH_USER:-ubuntu}"
export TF_VAR_ssh_pubkey_path="${SSH_PUBKEY_PATH:-$HOME/.ssh/id_ed25519.pub}"
export TF_VAR_base_image_name="${BASE_IMAGE_NAME:-}"
export TF_VAR_downloads_dir="${DOWNLOADS_DIR}"
export TF_VAR_pool_path="${POOL_PATH}"
export TF_VAR_libvirt_uri="${LIBVIRT_URI:-qemu:///system}"
export TF_VAR_libvirt_cpu_mode="${LIBVIRT_CPU_MODE:-host-passthrough}"
export TF_VAR_libvirt_qemu_user="$(libvirt_qemu_user)"
export TF_VAR_libvirt_qemu_group="$(libvirt_qemu_group)"

seclabel_mode=${LIBVIRT_SECLABEL_MODE:-auto}
if [[ "${seclabel_mode}" == "auto" ]]; then
  if command -v virsh >/dev/null 2>&1; then
    if virsh -c "${TF_VAR_libvirt_uri}" domcapabilities 2>/dev/null | grep -q "<model>apparmor</model>"; then
      seclabel_mode="apparmor"
    fi
  fi
  if [[ "${seclabel_mode}" != "apparmor" ]]; then
    if [[ -d /sys/kernel/security/apparmor ]] || command -v aa-status >/dev/null 2>&1 || command -v apparmor_status >/dev/null 2>&1; then
      seclabel_mode="apparmor"
    else
      seclabel_mode="none"
    fi
  fi
fi
export TF_VAR_libvirt_seclabel_mode="${seclabel_mode}"

if [[ ! -d "${INFRA_DIR}" ]]; then
  err "INFRA_DIR not found: ${INFRA_DIR}"
  exit 1
fi

cd "${INFRA_DIR}"
exec "${TOFU_BIN}" "$@"
