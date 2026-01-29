#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ROOT_DIR=$(cd "${SCRIPT_DIR}/../.." && pwd)

# shellcheck disable=SC1091
. "${ROOT_DIR}/scripts/lib/env.sh"
load_env

WORKDIR=${WORKDIR:-work}
ARTIFACT_DIR="${WORKDIR}/artifacts"
TS=$(date +%Y%m%d-%H%M%S)
OUT_DIR="${ARTIFACT_DIR}/${TS}"
ARCHIVE="${ARTIFACT_DIR}/${TS}.tar.gz"

INV_JSON="${WORKDIR}/inventory.json"
TOFU_OUT="${WORKDIR}/tofu-outputs.json"

SSH_USER=${SSH_USER:-ubuntu}
SSH_KEY=${ANSIBLE_SSH_PRIVATE_KEY:-$HOME/.ssh/id_ed25519}
LIBVIRT_URI=${LIBVIRT_URI:-qemu:///system}

mkdir -p "${OUT_DIR}"

# Local artifacts
for f in "${INV_JSON}" "${TOFU_OUT}"; do
  if [[ -f "${f}" ]]; then
    cp "${f}" "${OUT_DIR}/"
  fi
 done

# Libvirt diagnostics
virsh -c "${LIBVIRT_URI}" list --all > "${OUT_DIR}/virsh-list.txt" 2>/dev/null || true

mkdir -p "${OUT_DIR}/virsh"
while read -r dom; do
  [[ -z "${dom}" ]] && continue
  virsh -c "${LIBVIRT_URI}" dumpxml "${dom}" > "${OUT_DIR}/virsh/${dom}.xml" 2>/dev/null || true
 done < <(virsh -c "${LIBVIRT_URI}" list --all --name 2>/dev/null || true)

# Cloud-init logs (best-effort)
if [[ -f "${INV_JSON}" ]]; then
  mkdir -p "${OUT_DIR}/cloud-init"
  jq -c '.nodes[]' "${INV_JSON}" | while read -r node; do
    name=$(jq -r '.name' <<<"${node}")
    ip=$(jq -r '.mgmt_ip // empty' <<<"${node}")
    [[ -z "${ip}" ]] && continue
    ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=5 -i "${SSH_KEY}" "${SSH_USER}@${ip}" \
      "sudo cat /var/log/cloud-init.log" > "${OUT_DIR}/cloud-init/${name}.log" 2>/dev/null || true
    ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=5 -i "${SSH_KEY}" "${SSH_USER}@${ip}" \
      "sudo cat /var/log/cloud-init-output.log" > "${OUT_DIR}/cloud-init/${name}-output.log" 2>/dev/null || true
  done
fi

# Ansible logs (best-effort)
for f in ansible.log work/ansible.log; do
  if [[ -f "${f}" ]]; then
    cp "${f}" "${OUT_DIR}/" || true
  fi
 done

mkdir -p "${ARTIFACT_DIR}"
tar -czf "${ARCHIVE}" -C "${OUT_DIR}" .

echo "[collect-logs] Wrote ${ARCHIVE}"
