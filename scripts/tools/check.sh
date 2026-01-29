#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

log() { printf "%s\n" "[check] $*"; }
err() { printf "%s\n" "[check][ERROR] $*"; }
warn() { printf "%s\n" "[check][WARN] $*"; }

load_env() {
  if [[ -f .env ]]; then
    set -a
    # shellcheck disable=SC1091
    . ./.env
    set +a
  else
    warn ".env not found. Copy .env.example to .env and edit as needed."
  fi
}

check_cmd() {
  local cmd=$1
  local hint=$2
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    err "Missing command: ${cmd}. ${hint}"
    return 1
  fi
}

check_one_of() {
  local ok=1
  for cmd in "$@"; do
    if command -v "${cmd}" >/dev/null 2>&1; then
      ok=0
      break
    fi
  done
  if [[ ${ok} -ne 0 ]]; then
    err "Missing one of: $*"
    return 1
  fi
}

check_kvm() {
  if ! grep -E -q '(vmx|svm)' /proc/cpuinfo; then
    warn "CPU virtualization flags not detected (vmx/svm)."
  fi
  if [[ ! -e /dev/kvm ]]; then
    err "/dev/kvm not found. Ensure KVM modules are loaded."
    return 1
  fi
  if [[ ! -r /dev/kvm || ! -w /dev/kvm ]]; then
    err "Current user lacks read/write access to /dev/kvm. Add to kvm group and re-login."
    return 1
  fi
}

check_bridge() {
  if [[ -z "${SWARM_BRIDGE:-}" ]]; then
    err "SWARM_BRIDGE not set. Define it in .env."
    return 1
  fi
  if ! ip link show "${SWARM_BRIDGE}" >/dev/null 2>&1; then
    err "Bridge '${SWARM_BRIDGE}' not found. Create it before continuing."
    return 1
  fi
}

main() {
  local failed=0
  load_env

  check_cmd qemu-system-x86_64 "Install QEMU (qemu-system-x86)." || failed=1
  check_cmd qemu-img "Install qemu-utils/qemu-img." || failed=1
  check_one_of cloud-localds genisoimage xorriso || failed=1
  check_cmd ssh "Install openssh-client." || failed=1
  check_cmd make "Install make." || failed=1
  check_cmd docker "Install Docker Engine." || failed=1

  check_kvm || failed=1
  check_bridge || failed=1

  if [[ ${failed} -ne 0 ]]; then
    err "Prereqs check failed. See errors above."
    exit 1
  fi

  log "All prerequisite checks passed."
}

main "$@"
