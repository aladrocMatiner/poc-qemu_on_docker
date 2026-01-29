#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ROOT_DIR=$(cd "${SCRIPT_DIR}/../.." && pwd)

# shellcheck disable=SC1091
. "${ROOT_DIR}/scripts/lib/env.sh"
load_env
validate_network_env

WORKDIR=${WORKDIR:-work}
LIBVIRT_URI=${LIBVIRT_URI:-qemu:///system}
SSH_USER=${SSH_USER:-ubuntu}
MGMT_MODE=${MGMT_MODE:-user}
MGMT_NETWORK=${MGMT_NETWORK:-default}

OUT_JSON="${WORKDIR}/tofu-outputs.json"
INV_JSON="${WORKDIR}/inventory.json"
SCHEMA_VERSION="1"

mkdir -p "${WORKDIR}"

"${ROOT_DIR}/scripts/tofu/run.sh" output -json > "${OUT_JSON}"

lab_name=$(jq -r '.lab_name.value // empty' "${OUT_JSON}")
mgmt_mode=$(jq -r '.mgmt_mode.value // empty' "${OUT_JSON}")
mgmt_network=$(jq -r '.mgmt_network.value // empty' "${OUT_JSON}")

if [[ -z "${lab_name}" ]]; then
  err "Missing output: lab_name"
  exit 1
fi

nodes=$(jq -c '.nodes.value // empty' "${OUT_JSON}")
if [[ -z "${nodes}" || "${nodes}" == "null" ]]; then
  err "Missing output: nodes"
  exit 1
fi

get_ip_from_leases() {
  local network=$1
  local mac=$2
  if [[ -z "${network}" ]]; then
    return 1
  fi
  virsh -c "${LIBVIRT_URI}" net-dhcp-leases "${network}" 2>/dev/null | \
    awk -v m="${mac}" 'tolower($0) ~ tolower(m) {for(i=1;i<=NF;i++){if($i ~ /[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/){split($i,a,"/"); print a[1]; exit}}}'
}

nodes_json='[]'

while read -r node; do
  index=$(jq -r '.index' <<<"${node}")
  name=$(jq -r '.name' <<<"${node}")
  mgmt_mac=$(jq -r '.mgmt_mac' <<<"${node}")
  swarm_mac=$(jq -r '.swarm_mac' <<<"${node}")

  mgmt_ip=""
  if [[ "${mgmt_mode}" == "user" ]]; then
    mgmt_ip=$(get_ip_from_leases "${mgmt_network}" "${mgmt_mac}" || true)
  else
    mgmt_ip=$(get_ip_from_leases "${mgmt_network}" "${mgmt_mac}" || true)
  fi

  manual_var="NODE_MGMT_IP_NODE${index}"
  manual_ip=${!manual_var:-}
  if [[ -z "${mgmt_ip}" && -n "${manual_ip}" ]]; then
    mgmt_ip="${manual_ip}"
  fi

  if [[ -n "${mgmt_ip}" ]]; then
    ssh_target="ssh ${SSH_USER}@${mgmt_ip}"
  else
    ssh_target="Set ${manual_var} in .env and re-run inventory"
  fi

  node_obj=$(jq -n \
    --argjson index "${index}" \
    --arg name "${name}" \
    --arg mgmt_mac "${mgmt_mac}" \
    --arg swarm_mac "${swarm_mac}" \
    --arg mgmt_ip "${mgmt_ip}" \
    --arg ssh_target "${ssh_target}" \
    '{index:$index,name:$name,mgmt_mac:$mgmt_mac,swarm_mac:$swarm_mac,mgmt_ip:($mgmt_ip|select(length>0)),ssh_target:$ssh_target}')

  nodes_json=$(jq -c --argjson node "${node_obj}" '. + [$node]' <<<"${nodes_json}")

done < <(jq -c '.nodes.value[]' "${OUT_JSON}")

jq -n \
  --arg lab_name "${lab_name}" \
  --arg schema_version "${SCHEMA_VERSION}" \
  --arg mgmt_mode "${mgmt_mode}" \
  --arg mgmt_network "${mgmt_network}" \
  --argjson nodes "${nodes_json}" \
  '{lab_name:$lab_name, schema_version:$schema_version, mgmt_mode:$mgmt_mode, mgmt_network:$mgmt_network, nodes:$nodes}' \
  > "${INV_JSON}"

if ! jq -e '.lab_name and .schema_version and (.nodes | type == "array")' "${INV_JSON}" >/dev/null; then
  err "Inventory schema validation failed for ${INV_JSON}"
  exit 1
fi

printf "%s\n" "[inventory] Wrote ${INV_JSON}"
