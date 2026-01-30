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
  if [[ -n "${LIBVIRT_QEMU_USER:-}" ]]; then
    printf "%s" "${LIBVIRT_QEMU_USER}"
    return
  fi
  user=$(read_qemu_conf_value "user")
  printf "%s" "${user:-libvirt-qemu}"
}

libvirt_qemu_group() {
  local group=""
  if [[ -n "${LIBVIRT_QEMU_GROUP:-}" ]]; then
    printf "%s" "${LIBVIRT_QEMU_GROUP}"
    return
  fi
  group=$(read_qemu_conf_value "group")
  printf "%s" "${group:-kvm}"
}

read_qemu_conf_value() {
  local key=$1
  local conf="/etc/libvirt/qemu.conf"
  local value=""
  local pattern="s/^[[:space:]]*${key}[[:space:]]*=[[:space:]]*\"\\([^\"]\\+\\)\".*/\\1/p"

  if [[ -r "${conf}" ]]; then
    value=$(sed -n "${pattern}" "${conf}" | head -n1)
  elif command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
    value=$(sudo sed -n "${pattern}" "${conf}" | head -n1)
  fi

  printf "%s" "${value}"
}

ensure_libvirt_pool_permissions() {
  local pool_path=$1
  local fix=${LIBVIRT_POOL_FIX_PERMS:-1}
  if [[ "${fix}" != "1" ]]; then
    return 0
  fi
  if [[ -z "${pool_path}" ]]; then
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
    if [[ ! -d "${pool_path}" ]]; then
      log "Creating libvirt pool path ${pool_path} (owner ${qemu_user}:${qemu_group})"
      sudo install -d -o "${qemu_user}" -g "${qemu_group}" -m 0770 "${pool_path}"
    fi
    local needs_fix=0
    if ! sudo -u "${qemu_user}" test -w "${pool_path}" 2>/dev/null; then
      needs_fix=1
    elif sudo -u "${qemu_user}" find "${pool_path}" -mindepth 1 -maxdepth 1 ! -writable -print -quit 2>/dev/null | grep -q .; then
      needs_fix=1
    fi
    if [[ "${needs_fix}" -eq 1 ]]; then
      log "Fixing libvirt pool permissions for ${pool_path} (owner ${qemu_user}:${qemu_group})"
      sudo chown -R "${qemu_user}:${qemu_group}" "${pool_path}" || true
      sudo chmod -R u+rwX,g+rwX "${pool_path}" || true
    fi
  else
    warn "Pool permissions may need fixing. Run: sudo chown -R ${qemu_user}:${qemu_group} ${pool_path} && sudo chmod -R u+rwX,g+rwX ${pool_path}"
  fi
}

in_libvirt_group() {
  id -nG | tr ' ' '\n' | grep -qx "libvirt"
}

libvirt_group_contains_user() {
  command -v getent >/dev/null 2>&1 || return 1
  getent group libvirt | grep -q "\b${USER}\b"
}

maybe_reexec_with_libvirt_group() {
  local auto=${LIBVIRT_AUTO_SG:-1}
  if [[ "${auto}" != "1" || -n "${LIBVIRT_SG_REEXEC:-}" ]]; then
    return 0
  fi
  if [[ "${EUID}" -eq 0 ]]; then
    return 0
  fi
  if ! command -v sg >/dev/null 2>&1; then
    return 0
  fi
  if in_libvirt_group; then
    return 0
  fi
  if libvirt_group_contains_user; then
    local cmd
    cmd=$(printf "%q " "$0" "$@")
    exec sg libvirt -c "LIBVIRT_SG_REEXEC=1 ${cmd}"
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
