#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ROOT_DIR=$(cd "${SCRIPT_DIR}/../.." && pwd)

# shellcheck disable=SC1091
. "${ROOT_DIR}/scripts/lib/env.sh"
load_env

ANSIBLE_INVENTORY=${ANSIBLE_INVENTORY:-ansible/inventories/generated/inventory.ini}
ANSIBLE_SSH_USER=${ANSIBLE_SSH_USER:-${SSH_USER:-ubuntu}}
ANSIBLE_SSH_PRIVATE_KEY=${ANSIBLE_SSH_PRIVATE_KEY:-$HOME/.ssh/id_ed25519}

if [[ ! -f "${ANSIBLE_INVENTORY}" ]]; then
  err "Missing inventory: ${ANSIBLE_INVENTORY}. Run: make ansible-inventory"
  exit 1
fi

exec ansible -i "${ANSIBLE_INVENTORY}" -u "${ANSIBLE_SSH_USER}" --private-key "${ANSIBLE_SSH_PRIVATE_KEY}" swarm_all -m ping
