#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
. "${SCRIPT_DIR}/../lib/env.sh"

load_env

maybe_reexec_with_libvirt_group "$@"

NODE_INDEX=${NODE:-}
if [[ -z "${NODE_INDEX}" ]]; then
  echo "[lab-console][ERROR] NODE is required (e.g., make lab-console NODE=1)"
  exit 1
fi

DOMAIN=$(node_name "${NODE_INDEX}")

if ! command -v virsh >/dev/null 2>&1; then
  echo "[lab-console][ERROR] virsh not found. Install libvirt client tools."
  exit 1
fi

if ! virsh list --all --name | grep -qx "${DOMAIN}"; then
  echo "[lab-console][ERROR] Domain '${DOMAIN}' not found. Run 'make lab-up' first."
  exit 1
fi

echo "[lab-console] Connecting to ${DOMAIN} serial console."
echo "[lab-console] Exit with: Ctrl+]"

virsh console "${DOMAIN}"
