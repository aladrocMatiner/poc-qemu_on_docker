#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
. "${SCRIPT_DIR}/../lib/env.sh"

load_env

NODE_INDEX=${NODE:-}
if [[ -z "${NODE_INDEX}" ]]; then
  echo "[lab-ssh][ERROR] NODE is required (e.g., make lab-ssh NODE=1)"
  exit 1
fi

INV_JSON=${WORKDIR:-work}/inventory.json
if [[ ! -f "${INV_JSON}" ]]; then
  echo "[lab-ssh][ERROR] Inventory not found at ${INV_JSON}. Run 'make lab-status' first."
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "[lab-ssh][ERROR] jq not found. Install jq."
  exit 1
fi

node=$(jq -c --argjson idx "${NODE_INDEX}" '.nodes[] | select(.index==$idx)' "${INV_JSON}")
if [[ -z "${node}" ]]; then
  echo "[lab-ssh][ERROR] Node ${NODE_INDEX} not found in inventory."
  exit 1
fi

ssh_target=$(jq -r '.ssh_target' <<<"${node}")
if [[ -z "${ssh_target}" || "${ssh_target}" == "null" ]]; then
  echo "[lab-ssh][ERROR] ssh_target missing in inventory. Re-run make lab-status."
  exit 1
fi

if [[ "${ssh_target}" == Set* ]]; then
  echo "[lab-ssh][ERROR] ${ssh_target}"
  exit 1
fi

exec ${ssh_target}
