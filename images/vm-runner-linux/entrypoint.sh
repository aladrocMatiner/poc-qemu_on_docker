#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

VM_NAME=${VM_NAME:-vm-runner-linux}
VM_MAC=${VM_MAC:-52:54:00:ab:cd:41}
VM_DISK=${VM_DISK:-/vm/images/linux.qcow2}
VM_SEED=${VM_SEED:-/vm/seeds/linux-seed.iso}
VM_NET_MODE=${VM_NET_MODE:-bridge}
VM_BRIDGE=${VM_BRIDGE:-br0}
VM_TAP=${VM_TAP:-tap0}
VM_ACCEL=${VM_ACCEL:-auto}
VM_SSH_FWD_PORT=${VM_SSH_FWD_PORT:-2222}
VM_CPU=${VM_CPU:-2}
VM_RAM_MB=${VM_RAM_MB:-2048}

if [[ ! -e "${VM_DISK}" ]]; then
  echo "[vm-runner] missing VM_DISK: ${VM_DISK}" >&2
  exit 1
fi

if [[ ! -e "${VM_SEED}" ]]; then
  echo "[vm-runner] missing VM_SEED: ${VM_SEED}" >&2
  exit 1
fi

net_args=()
tap_created=0

cleanup() {
  if [[ "${tap_created}" == "1" ]]; then
    ip link set "${VM_TAP}" down >/dev/null 2>&1 || true
    ip tuntap del dev "${VM_TAP}" mode tap >/dev/null 2>&1 || true
  fi
}

if [[ "${VM_NET_MODE}" == "user" ]]; then
  net_args+=("-netdev" "user,id=net0,hostfwd=tcp::${VM_SSH_FWD_PORT}-:22")
  net_args+=("-device" "virtio-net-pci,netdev=net0,mac=${VM_MAC}")
elif [[ "${VM_NET_MODE}" == "bridge" ]]; then
  if ! ip link show "${VM_BRIDGE}" >/dev/null 2>&1; then
    echo "[vm-runner] bridge ${VM_BRIDGE} not found" >&2
    exit 1
  fi
  ip tuntap add dev "${VM_TAP}" mode tap
  ip link set "${VM_TAP}" up
  ip link set "${VM_TAP}" master "${VM_BRIDGE}"
  tap_created=1
  net_args+=("-netdev" "tap,id=net0,ifname=${VM_TAP},script=no,downscript=no")
  net_args+=("-device" "virtio-net-pci,netdev=net0,mac=${VM_MAC}")
else
  echo "[vm-runner] unsupported VM_NET_MODE=${VM_NET_MODE} (supported: user, bridge)" >&2
  exit 1
fi

kvm_args=()
if [[ "${VM_ACCEL}" == "kvm" ]]; then
  kvm_args+=("-enable-kvm" "-cpu" "host")
elif [[ "${VM_ACCEL}" == "tcg" ]]; then
  kvm_args+=("-accel" "tcg" "-cpu" "max")
else
  if [[ -c /dev/kvm && -r /dev/kvm && -w /dev/kvm ]]; then
    kvm_args+=("-enable-kvm" "-cpu" "host")
  else
    echo "[vm-runner] /dev/kvm not available, falling back to TCG" >&2
    kvm_args+=("-accel" "tcg" "-cpu" "max")
  fi
fi

trap cleanup EXIT

qemu-system-x86_64 \
  -name "${VM_NAME}" \
  "${kvm_args[@]}" \
  -smp "${VM_CPU}" \
  -m "${VM_RAM_MB}" \
  -drive "file=${VM_DISK},if=virtio,cache=writeback" \
  -drive "file=${VM_SEED},format=raw,if=virtio" \
  -nographic \
  "${net_args[@]}" &

qemu_pid=$!
trap 'kill -TERM ${qemu_pid} >/dev/null 2>&1 || true' TERM INT
wait "${qemu_pid}"
