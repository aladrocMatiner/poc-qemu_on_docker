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
  echo "[image-info][ERROR] BASE_IMAGE_NAME must be set in .env"
  exit 1
fi

IMAGE_PATH="${DOWNLOADS_DIR}/${BASE_IMAGE_NAME}"

echo "[image-info] Path: ${IMAGE_PATH}"
if [[ -f "${IMAGE_PATH}" ]]; then
  echo "[image-info] Exists: yes"
  if command -v ls >/dev/null 2>&1; then
    ls -lh "${IMAGE_PATH}" | awk '{print "[image-info] Size: "$5}'
  fi
else
  echo "[image-info] Exists: no"
fi

if [[ -n "${BASE_IMAGE_SHA256}" ]]; then
  if command -v sha256sum >/dev/null 2>&1 && [[ -f "${IMAGE_PATH}" ]]; then
    actual=$(sha256sum "${IMAGE_PATH}" | awk '{print $1}')
    if [[ "${actual}" == "${BASE_IMAGE_SHA256}" ]]; then
      echo "[image-info] Checksum: OK"
    else
      echo "[image-info] Checksum: MISMATCH"
      echo "[image-info] expected=${BASE_IMAGE_SHA256}"
      echo "[image-info] actual=${actual}"
    fi
  else
    echo "[image-info] Checksum: unavailable (sha256sum or image missing)"
  fi
else
  echo "[image-info] Checksum: not set"
fi
