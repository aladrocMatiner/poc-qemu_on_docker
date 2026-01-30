#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
. "${SCRIPT_DIR}/../lib/env.sh"

load_env

LAB_NAME=${LAB_NAME:-swarm-lab}
LIBVIRT_URI=${LIBVIRT_URI:-qemu:///system}

if command -v virsh >/dev/null 2>&1; then
  domains=$(virsh -c "${LIBVIRT_URI}" list --all --name | grep "^${LAB_NAME}-" || true)
else
  domains=""
fi

# First, try OpenTofu destroy (best-effort).
"${SCRIPT_DIR}/../tofu/run.sh" destroy -auto-approve || true

if [[ -z "${domains}" ]]; then
  echo "[lab-destroy] No lab domains found in libvirt."
  exit 0
fi

echo "[lab-destroy] Removing libvirt domains for lab '${LAB_NAME}' (best-effort)."
while IFS= read -r dom; do
  [[ -z "${dom}" ]] && continue
  # Stop if running
  if virsh -c "${LIBVIRT_URI}" domstate "${dom}" 2>/dev/null | grep -qi running; then
    virsh -c "${LIBVIRT_URI}" destroy "${dom}" || true
  fi
  virsh -c "${LIBVIRT_URI}" undefine "${dom}" --remove-all-storage --nvram || true
  echo "[lab-destroy] Removed ${dom}"
done <<<"${domains}"
