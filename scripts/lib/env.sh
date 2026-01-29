#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

log() { printf "%s\n" "[env] $*"; }
err() { printf "%s\n" "[env][ERROR] $*"; }

load_env() {
  if [[ -f .env ]]; then
    set -a
    # shellcheck disable=SC1091
    . ./.env
    set +a
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
