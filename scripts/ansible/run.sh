#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ROOT_DIR=$(cd "${SCRIPT_DIR}/../.." && pwd)

# shellcheck disable=SC1091
. "${ROOT_DIR}/scripts/lib/env.sh"
load_env

ANSIBLE_DIR=${ANSIBLE_DIR:-ansible}
ANSIBLE_CFG=${ANSIBLE_CFG:-ansible/ansible.cfg}
ANSIBLE_INVENTORY=${ANSIBLE_INVENTORY:-ansible/inventories/generated/inventory.ini}
ANSIBLE_SSH_USER=${ANSIBLE_SSH_USER:-${SSH_USER:-ubuntu}}
ANSIBLE_SSH_PRIVATE_KEY=${ANSIBLE_SSH_PRIVATE_KEY:-$HOME/.ssh/id_ed25519}
ANSIBLE_FORKS=${ANSIBLE_FORKS:-10}
ANSIBLE_BECOME=${ANSIBLE_BECOME:-1}
ANSIBLE_LIMIT=${ANSIBLE_LIMIT:-}
ANSIBLE_TAGS=${ANSIBLE_TAGS:-}
ANSIBLE_EXTRA_VARS_FILE=${ANSIBLE_EXTRA_VARS_FILE:-ansible/group_vars/all.yml}

if [[ $# -lt 1 ]]; then
  err "Usage: scripts/ansible/run.sh <playbook>"
  exit 1
fi

PLAYBOOK=$1
shift || true

if [[ ! -f "${ANSIBLE_INVENTORY}" ]]; then
  err "Missing inventory: ${ANSIBLE_INVENTORY}. Run: make ansible-inventory"
  exit 1
fi

if [[ -f "${ANSIBLE_CFG}" ]]; then
  export ANSIBLE_CONFIG="${ANSIBLE_CFG}"
fi

cmd=(ansible-playbook -i "${ANSIBLE_INVENTORY}" -u "${ANSIBLE_SSH_USER}" --private-key "${ANSIBLE_SSH_PRIVATE_KEY}" --forks "${ANSIBLE_FORKS}")

if [[ "${ANSIBLE_BECOME}" == "1" ]]; then
  cmd+=(--become)
fi

if [[ -n "${ANSIBLE_LIMIT}" ]]; then
  cmd+=(--limit "${ANSIBLE_LIMIT}")
fi

if [[ -n "${ANSIBLE_TAGS}" ]]; then
  cmd+=(--tags "${ANSIBLE_TAGS}")
fi

if [[ -f "${ANSIBLE_EXTRA_VARS_FILE}" ]]; then
  cmd+=(--extra-vars "@${ANSIBLE_EXTRA_VARS_FILE}")
fi

exec "${cmd[@]}" "${PLAYBOOK}" "$@"
