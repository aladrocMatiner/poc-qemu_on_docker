#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
. "${SCRIPT_DIR}/../lib/env.sh"

load_env

BASE_IMAGE_URL=${BASE_IMAGE_URL:-}
BASE_IMAGE_NAME=${BASE_IMAGE_NAME:-}
DOWNLOADS_DIR=${DOWNLOADS_DIR:-work/downloads}

if [[ -z "${BASE_IMAGE_URL}" || -z "${BASE_IMAGE_NAME}" ]]; then
  echo "[image-fetch][ERROR] BASE_IMAGE_URL and BASE_IMAGE_NAME must be set in .env"
  exit 1
fi

mkdir -p "${DOWNLOADS_DIR}"

IMAGE_PATH="${DOWNLOADS_DIR}/${BASE_IMAGE_NAME}"

if [[ -f "${IMAGE_PATH}" ]]; then
  echo "[image-fetch] Image already exists: ${IMAGE_PATH}"
  exit 0
fi

if command -v curl >/dev/null 2>&1; then
  echo "[image-fetch] Downloading with curl..."
  curl -fL "${BASE_IMAGE_URL}" -o "${IMAGE_PATH}"
elif command -v wget >/dev/null 2>&1; then
  echo "[image-fetch] Downloading with wget..."
  wget -O "${IMAGE_PATH}" "${BASE_IMAGE_URL}"
else
  echo "[image-fetch][ERROR] curl or wget is required"
  exit 1
fi

echo "[image-fetch] Downloaded: ${IMAGE_PATH}"

if [[ -n "${BASE_IMAGE_SHA256:-}" ]]; then
  "${SCRIPT_DIR}/verify.sh"
fi
