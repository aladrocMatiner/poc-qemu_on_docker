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
CASE_PREFIX=${CASE_PREFIX:-case00}
VM_RUNNER_SERVICE=${VM_RUNNER_SERVICE:-}

if [[ ! -f "${INV_JSON}" ]]; then
  err "Missing ${INV_JSON}. Run: make lab-status"
  exit 1
fi

svc_web="${STACK_NAME}_${CASE_PREFIX}-web"
svc_ping="${STACK_NAME}_${CASE_PREFIX}-ping"
services=("${svc_web}" "${svc_ping}")
if [[ -n "${VM_RUNNER_SERVICE}" ]]; then
  services+=("${VM_RUNNER_SERVICE}")
fi

ssh_opts=(
  -o BatchMode=yes
  -o StrictHostKeyChecking=accept-new
)
if [[ -n "${SSH_KEY}" && -f "${SSH_KEY}" ]]; then
  ssh_opts+=(-i "${SSH_KEY}")
fi

jq -r '.nodes[] | select(.mgmt_ip) | "\(.name)|\(.mgmt_ip)"' "${INV_JSON}" | while IFS='|' read -r node ip; do
  if [[ -z "${printed_header:-}" ]]; then
    printf "%-64s %-20s %-15s %s\n" "CONTAINER" "NODE" "IP" "SERVICE"
    printed_header=1
  fi
  out=$(ssh "${ssh_opts[@]}" "${SSH_USER}@${ip}" bash -s <<EOF_REMOTE || true
set -euo pipefail
DOCKER=docker
if ! \$DOCKER ps >/dev/null 2>&1; then
  if sudo -n docker ps >/dev/null 2>&1; then
    DOCKER="sudo -n docker"
  else
    echo "docker access denied on ${node}. Add user to docker group or use sudo."
    exit 0
  fi
fi
HOST=$(hostname -s 2>/dev/null || hostname)
for svc in "${services[@]}"; do
  \$DOCKER ps --filter label=com.docker.swarm.service.name=\${svc} --format '{{.ID}} {{.Names}}' | while read -r id name; do
    if [[ -n "\${id}" ]]; then
      ip=\$(\$DOCKER inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "\${id}")
      printf "%s %s %s\\n" "\${name}" "\${ip}" "\${svc}"
    fi
  done
done
EOF_REMOTE
)
  if [[ -n "${out}" ]]; then
    while IFS=' ' read -r name ipaddr svc; do
      printf "%-64s %-20s %-15s %s\n" "${name}" "${node}" "${ipaddr}" "${svc}"
    done <<<"${out}"
  fi
done
