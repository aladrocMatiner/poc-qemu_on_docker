#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ROOT_DIR=$(cd "${SCRIPT_DIR}/../.." && pwd)

# shellcheck disable=SC1091
. "${ROOT_DIR}/scripts/lib/env.sh"
load_env

HOST_NETWORK_ASSUME_YES=${HOST_NETWORK_ASSUME_YES:-0}
SWARM_BRIDGE=${SWARM_BRIDGE:-}
MGMT_BRIDGE=${MGMT_BRIDGE:-}

if [[ "${HOST_NETWORK_ASSUME_YES}" != "1" ]]; then
  err "Refusing to run without HOST_NETWORK_ASSUME_YES=1"
  exit 1
fi

if [[ -z "${SWARM_BRIDGE}" ]]; then
  err "SWARM_BRIDGE is required"
  exit 1
fi

create_bridge() {
  local br=$1
  if ip link show "${br}" >/dev/null 2>&1; then
    echo "[network-setup] Bridge ${br} already exists"
    return 0
  fi
  sudo ip link add name "${br}" type bridge
  sudo ip link set "${br}" up
  echo "[network-setup] Created bridge ${br}"
}

create_bridge "${SWARM_BRIDGE}"

if [[ -n "${MGMT_BRIDGE}" ]]; then
  create_bridge "${MGMT_BRIDGE}"
else
  echo "[network-setup] MGMT_BRIDGE not set; skipping"
fi

cat <<'MSG'
[network-setup] NOTE: This helper does not attach physical NICs or assign IPs.
Rollback: sudo ip link set <bridge> down && sudo ip link delete <bridge> type bridge
MSG
