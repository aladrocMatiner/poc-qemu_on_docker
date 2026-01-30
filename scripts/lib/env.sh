#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

log() { printf "%s\n" "[env] $*"; }
err() { printf "%s\n" "[env][ERROR] $*"; }
warn() { printf "%s\n" "[env][WARN] $*"; }

load_env() {
  if [[ -f .env ]]; then
    while IFS= read -r line || [[ -n "$line" ]]; do
      [[ -z "${line}" ]] && continue
      [[ "${line}" =~ ^[[:space:]]*# ]] && continue
      # Support optional "export " prefix.
      line="${line#export }"
      if [[ "${line}" =~ ^([A-Za-z_][A-Za-z0-9_]*)=(.*)$ ]]; then
        local key=${BASH_REMATCH[1]}
        if [[ -z "${!key-}" ]]; then
          export "${line}"
        fi
      fi
    done < ./.env
  fi
}

require_var() {
  local name=$1
  local val=${!name:-}
  if [[ -z "${val}" ]]; then
    err "Missing required env var: ${name}"
    return 1
  fi
}

require_bridge() {
  local name=$1
  if ! ip link show "${name}" >/dev/null 2>&1; then
    err "Bridge '${name}' not found. Create it before continuing."
    return 1
  fi
}

validate_network_env() {
  local mode=${MGMT_MODE:-user}
  if [[ "${mode}" != "user" && "${mode}" != "bridge" ]]; then
    err "MGMT_MODE must be 'user' or 'bridge' (got: ${mode})"
    return 1
  fi
  require_var SWARM_BRIDGE || return 1
  require_bridge "${SWARM_BRIDGE}" || return 1
  if [[ "${mode}" == "bridge" ]]; then
    require_var MGMT_BRIDGE || return 1
    require_bridge "${MGMT_BRIDGE}" || return 1
  fi
  if [[ "${mode}" == "user" && -n "${MGMT_NETWORK_CIDR:-}" ]]; then
    local network_name=${MGMT_NETWORK:-default}
    if [[ "${network_name}" == "default" ]]; then
      err "MGMT_NETWORK_CIDR is set but MGMT_NETWORK=default. Use a lab-specific network name to avoid clobbering the default network."
      return 1
    fi
  fi
}

libvirt_qemu_user() {
  local user=""
  if [[ -f /etc/libvirt/qemu.conf ]]; then
    user=$(sed -n 's/^[[:space:]]*user[[:space:]]*=[[:space:]]*"\\([^"]\\+\\)".*/\\1/p' /etc/libvirt/qemu.conf | head -n1)
  fi
  printf "%s" "${user:-libvirt-qemu}"
}

libvirt_qemu_group() {
  local group=""
  if [[ -f /etc/libvirt/qemu.conf ]]; then
    group=$(sed -n 's/^[[:space:]]*group[[:space:]]*=[[:space:]]*"\\([^"]\\+\\)".*/\\1/p' /etc/libvirt/qemu.conf | head -n1)
  fi
  printf "%s" "${group:-kvm}"
}

ensure_libvirt_pool_permissions() {
  local pool_path=$1
  local fix=${LIBVIRT_POOL_FIX_PERMS:-1}
  if [[ "${fix}" != "1" ]]; then
    return 0
  fi
  if [[ -z "${pool_path}" || ! -d "${pool_path}" ]]; then
    return 0
  fi

  local qemu_user qemu_group
  qemu_user=$(libvirt_qemu_user)
  qemu_group=$(libvirt_qemu_group)

  if ! command -v sudo >/dev/null 2>&1; then
    warn "sudo not available to fix pool permissions for ${pool_path}"
    return 0
  fi

  if sudo -n true 2>/dev/null; then
    if ! sudo -u "${qemu_user}" test -w "${pool_path}" 2>/dev/null; then
      log "Fixing libvirt pool permissions for ${pool_path} (owner ${qemu_user}:${qemu_group})"
      sudo chown -R "${qemu_user}:${qemu_group}" "${pool_path}" || true
      sudo chmod -R u+rwX,g+rwX "${pool_path}" || true
    fi
  else
    warn "Pool permissions may need fixing. Run: sudo chown -R ${qemu_user}:${qemu_group} ${pool_path} && sudo chmod -R u+rwX,g+rwX ${pool_path}"
  fi
}

node_name() {
  local i=$1
  local name=${LAB_NAME:-swarm-lab}
  printf "%s-node%s" "${name}" "${i}"
}

mac_for_index() {
  local prefix=$1
  local offset=$2
  local idx=$3
  printf "%s:%02x" "${prefix}" "$((offset + idx))"
}

node_mac_mgmt() {
  local i=$1
  local prefix=${MAC_PREFIX:-52:54:00:ab:cd}
  local offset=${MAC_OFFSET_MGMT:-16}
  mac_for_index "${prefix}" "${offset}" "${i}"
}

node_mac_swarm() {
  local i=$1
  local prefix=${MAC_PREFIX:-52:54:00:ab:cd}
  local offset=${MAC_OFFSET_SWARM:-32}
  mac_for_index "${prefix}" "${offset}" "${i}"
}
