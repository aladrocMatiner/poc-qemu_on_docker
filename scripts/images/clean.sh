#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
. "${SCRIPT_DIR}/../lib/env.sh"

load_env

BASE_IMAGE_NAME=${BASE_IMAGE_NAME:-}
DOWNLOADS_DIR=${DOWNLOADS_DIR:-work/downloads}

if [[ -z "${BASE_IMAGE_NAME}" ]]; then
  echo "[image-clean][ERROR] BASE_IMAGE_NAME must be set in .env"
  exit 1
fi

IMAGE_PATH="${DOWNLOADS_DIR}/${BASE_IMAGE_NAME}"

if [[ -f "${IMAGE_PATH}" ]]; then
  rm -f "${IMAGE_PATH}"
  echo "[image-clean] Removed: ${IMAGE_PATH}"
else
  echo "[image-clean] No image to remove at ${IMAGE_PATH}"
fi
