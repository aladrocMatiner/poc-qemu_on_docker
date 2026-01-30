#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
. "${SCRIPT_DIR}/../lib/env.sh"

load_env

BASE_IMAGE_NAME=${BASE_IMAGE_NAME:-}
BASE_IMAGE_SHA256=${BASE_IMAGE_SHA256:-}
DOWNLOADS_DIR=${DOWNLOADS_DIR:-work/downloads}

if [[ -z "${BASE_IMAGE_NAME}" ]]; then
  echo "[image-verify][ERROR] BASE_IMAGE_NAME must be set in .env"
  exit 1
fi

IMAGE_PATH="${DOWNLOADS_DIR}/${BASE_IMAGE_NAME}"

if [[ ! -f "${IMAGE_PATH}" ]]; then
  echo "[image-verify][ERROR] Image not found: ${IMAGE_PATH}"
  exit 1
fi

if [[ -z "${BASE_IMAGE_SHA256}" ]]; then
  echo "[image-verify] BASE_IMAGE_SHA256 not set; skipping checksum verification"
  exit 0
fi

if ! command -v sha256sum >/dev/null 2>&1; then
  echo "[image-verify][ERROR] sha256sum is required"
  exit 1
fi

actual=$(sha256sum "${IMAGE_PATH}" | awk '{print $1}')
if [[ "${actual}" != "${BASE_IMAGE_SHA256}" ]]; then
  echo "[image-verify][ERROR] Checksum mismatch"
  echo "[image-verify] expected=${BASE_IMAGE_SHA256}"
  echo "[image-verify] actual=${actual}"
  exit 1
fi

echo "[image-verify] Checksum OK"
