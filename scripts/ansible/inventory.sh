#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ROOT_DIR=$(cd "${SCRIPT_DIR}/../.." && pwd)

# shellcheck disable=SC1091
. "${ROOT_DIR}/scripts/lib/env.sh"
load_env

WORKDIR=${WORKDIR:-work}
ANSIBLE_DIR=${ANSIBLE_DIR:-ansible}
ANSIBLE_INVENTORY=${ANSIBLE_INVENTORY:-ansible/inventories/generated/inventory.ini}
ANSIBLE_SSH_USER=${ANSIBLE_SSH_USER:-${SSH_USER:-ubuntu}}
ANSIBLE_SSH_PRIVATE_KEY=${ANSIBLE_SSH_PRIVATE_KEY:-$HOME/.ssh/id_ed25519}

INV_JSON="${WORKDIR}/inventory.json"
INV_OUT="${ANSIBLE_INVENTORY}"

if [[ ! -f "${INV_JSON}" ]]; then
  err "Inventory JSON not found: ${INV_JSON}. Run: make lab-status"
  exit 1
fi

mkdir -p "$(dirname "${INV_OUT}")"

nodes=$(jq -c '.nodes[]' "${INV_JSON}")
if [[ -z "${nodes}" ]]; then
  err "No nodes found in ${INV_JSON}"
  exit 1
fi

{
  echo "[swarm_managers]"
  jq -c '.nodes[] | select(.index==1)' "${INV_JSON}" | while read -r node; do
    name=$(jq -r '.name' <<<"${node}")
    ip=$(jq -r '.mgmt_ip // empty' <<<"${node}")
    if [[ -z "${ip}" ]]; then
      err "Missing mgmt_ip for ${name}. Set NODE_MGMT_IP_NODE1 and re-run inventory."
      exit 1
    fi
    echo "${name} ansible_host=${ip} ansible_user=${ANSIBLE_SSH_USER} ansible_ssh_private_key_file=${ANSIBLE_SSH_PRIVATE_KEY}"
  done

  echo ""
  echo "[swarm_workers]"
  jq -c '.nodes[] | select(.index>1)' "${INV_JSON}" | while read -r node; do
    name=$(jq -r '.name' <<<"${node}")
    ip=$(jq -r '.mgmt_ip // empty' <<<"${node}")
    if [[ -z "${ip}" ]]; then
      err "Missing mgmt_ip for ${name}. Set NODE_MGMT_IP_NODE${name##*-node} and re-run inventory."
      exit 1
    fi
    echo "${name} ansible_host=${ip} ansible_user=${ANSIBLE_SSH_USER} ansible_ssh_private_key_file=${ANSIBLE_SSH_PRIVATE_KEY}"
  done

  echo ""
  echo "[swarm_all:children]"
  echo "swarm_managers"
  echo "swarm_workers"
} > "${INV_OUT}"

printf "%s\n" "[ansible] Wrote ${INV_OUT}"
