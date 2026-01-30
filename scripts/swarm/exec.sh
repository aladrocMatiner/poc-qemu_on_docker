#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ROOT_DIR=$(cd "${SCRIPT_DIR}/../.." && pwd)

# shellcheck disable=SC1091
. "${ROOT_DIR}/scripts/lib/env.sh"
load_env

INV_JSON=${WORKDIR:-work}/inventory.json
SSH_USER=${SSH_USER:-ubuntu}
SSH_KEY=${ANSIBLE_SSH_PRIVATE_KEY:-${SSH_PRIVATE_KEY:-}}
STACK_NAME=${STACK_NAME:-phase2-linux-demo}
CONTAINER_NAME=${NAME:-${CONTAINER_NAME:-${1:-}}}
EXEC_SHELL=${EXEC_SHELL:-/bin/sh}

if [[ -z "${CONTAINER_NAME}" ]]; then
  err "Missing container name. Use: make ansible-swarm-poc-qemu-case00-exec <container_name> (or NAME=...)."
  exit 1
fi

if [[ ! -f "${INV_JSON}" ]]; then
  err "Missing ${INV_JSON}. Run: make lab-status"
  exit 1
fi

ssh_opts=(
  -o BatchMode=yes
  -o StrictHostKeyChecking=accept-new
)
if [[ -n "${SSH_KEY}" && -f "${SSH_KEY}" ]]; then
  ssh_opts+=(-i "${SSH_KEY}")
fi

found_node=""
found_ip=""
found_id=""

jq -r '.nodes[] | select(.mgmt_ip) | "\(.name)|\(.mgmt_ip)"' "${INV_JSON}" | while IFS='|' read -r node ip; do
  cid=$(ssh "${ssh_opts[@]}" "${SSH_USER}@${ip}" bash -s <<EOF_REMOTE || true
set -euo pipefail
DOCKER=docker
if ! \$DOCKER ps >/dev/null 2>&1; then
  if sudo -n docker ps >/dev/null 2>&1; then
    DOCKER="sudo -n docker"
  else
    exit 0
  fi
fi
match=$(\$DOCKER ps --format '{{.Names}} {{.ID}}' | awk -v n="${CONTAINER_NAME}" '$1==n {print $2; exit}')
if [[ -n "${match}" ]]; then
  echo "${match}"
fi
EOF_REMOTE
)
  if [[ -n "${cid}" ]]; then
    found_node="${node}"
    found_ip="${ip}"
    found_id="${cid}"
    break
  fi
done

if [[ -z "${found_id}" ]]; then
  err "Container not found: ${CONTAINER_NAME}. Run: make ansible-swarm-poc-qemu-case00-exec-list"
  exit 1
fi

log "Connecting to ${CONTAINER_NAME} on ${found_node} (${found_ip})"
ssh -t "${ssh_opts[@]}" "${SSH_USER}@${found_ip}" "docker ps >/dev/null 2>&1 || sudo -n docker ps >/dev/null 2>&1; if docker ps >/dev/null 2>&1; then docker exec -it ${found_id} ${EXEC_SHELL}; else sudo -n docker exec -it ${found_id} ${EXEC_SHELL}; fi"
