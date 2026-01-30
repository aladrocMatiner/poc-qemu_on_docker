#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

log() { printf "%s\n" "[nested-kvm] $*"; }
err() { printf "%s\n" "[nested-kvm][ERROR] $*"; }

if ! command -v lscpu >/dev/null 2>&1; then
  err "lscpu not found. Install util-linux."; exit 1; fi

cpu_vendor=$(lscpu | awk -F: '/Vendor ID/ {gsub(/ /, "", $2); print $2}')
flags=$(lscpu | awk -F: '/Flags/ {print $2}')

if [[ "${flags}" != *vmx* && "${flags}" != *svm* ]]; then
  err "CPU virtualization flags not present (vmx/svm)."; exit 1; fi

if [[ -e /dev/kvm ]]; then
  log "/dev/kvm exists"
else
  err "/dev/kvm missing"; exit 1
fi

if [[ "${cpu_vendor}" == "GenuineIntel" ]]; then
  mod=1
  if [[ -f /sys/module/kvm_intel/parameters/nested ]]; then
    mod=$(cat /sys/module/kvm_intel/parameters/nested)
  fi
  log "Intel nested: ${mod} (Y/1 means enabled)"
elif [[ "${cpu_vendor}" == "AuthenticAMD" ]]; then
  mod=1
  if [[ -f /sys/module/kvm_amd/parameters/nested ]]; then
    mod=$(cat /sys/module/kvm_amd/parameters/nested)
  fi
  log "AMD nested: ${mod} (1 means enabled)"
else
  err "Unknown CPU vendor: ${cpu_vendor}"; exit 1
fi

log "OK: virtualization flags present"
