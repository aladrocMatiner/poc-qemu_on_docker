#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ROOT_DIR=$(cd "${SCRIPT_DIR}/../.." && pwd)

ANSIBLE_DIR=${ANSIBLE_DIR:-ansible}
REQ_FILE="${ANSIBLE_DIR}/requirements.yml"

if [[ ! -f "${REQ_FILE}" ]]; then
  echo "[ansible] No requirements.yml found. Skipping."
  exit 0
fi

exec ansible-galaxy collection install -r "${REQ_FILE}"
