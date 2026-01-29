#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

BOOTSTRAP_ASSUME_YES=${BOOTSTRAP_ASSUME_YES:-0}
BOOTSTRAP_INSTALL_DOCKER=${BOOTSTRAP_INSTALL_DOCKER:-1}
BOOTSTRAP_INSTALL_QEMU=${BOOTSTRAP_INSTALL_QEMU:-1}
BOOTSTRAP_INSTALL_CLOUDTOOLS=${BOOTSTRAP_INSTALL_CLOUDTOOLS:-1}
BOOTSTRAP_INSTALL_NETTOOLS=${BOOTSTRAP_INSTALL_NETTOOLS:-1}
BOOTSTRAP_INSTALL_TOFU=${BOOTSTRAP_INSTALL_TOFU:-1}
BOOTSTRAP_INSTALL_LIBVIRT=${BOOTSTRAP_INSTALL_LIBVIRT:-1}
BOOTSTRAP_INSTALL_ANSIBLE=${BOOTSTRAP_INSTALL_ANSIBLE:-1}

OS_FAMILY=""
OS_ID=""
OS_VERSION_CODENAME=""
SUDO=""

INSTALLED_ITEMS=()
SKIPPED_ITEMS=()
WARNINGS=()

log() { printf "%s\n" "[bootstrap] $*"; }
warn() { printf "%s\n" "[bootstrap][WARN] $*"; }
err() { printf "%s\n" "[bootstrap][ERROR] $*"; }

die() { err "$*"; exit 1; }

confirm_or_exit() {
  if [[ "${BOOTSTRAP_ASSUME_YES}" == "1" ]]; then
    return 0
  fi
  printf "%s\n" "This will perform privileged actions (package installs, service enable, group changes)."
  printf "%s" "Continue? [y/N]: "
  read -r reply
  if [[ ! "${reply}" =~ ^[Yy]$ ]]; then
    die "Aborted by user. Set BOOTSTRAP_ASSUME_YES=1 to skip prompts."
  fi
}

require_sudo() {
  if [[ "${EUID}" -eq 0 ]]; then
    SUDO=""
    return 0
  fi
  if command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
    return 0
  fi
  die "sudo not found and not running as root."
}

detect_distro() {
  if [[ ! -r /etc/os-release ]]; then
    die "Cannot detect OS: /etc/os-release not found."
  fi
  # shellcheck disable=SC1091
  . /etc/os-release
  OS_ID=${ID}
  OS_VERSION_CODENAME=${VERSION_CODENAME:-${UBUNTU_CODENAME:-}}

  case "${OS_ID}" in
    ubuntu|debian)
      OS_FAMILY="debian"
      ;;
    rhel|rocky|almalinux|centos|fedora)
      OS_FAMILY="rhel"
      ;;
    *)
      if [[ "${ID_LIKE:-}" == *"debian"* ]]; then
        OS_FAMILY="debian"
      elif [[ "${ID_LIKE:-}" == *"rhel"* ]] || [[ "${ID_LIKE:-}" == *"fedora"* ]] || [[ "${ID_LIKE:-}" == *"centos"* ]]; then
        OS_FAMILY="rhel"
      else
        die "Unsupported distro: ${OS_ID}. Supported: Debian/Ubuntu, RHEL/Rocky/Alma/Fedora."
      fi
      ;;
  esac

  if [[ "${OS_FAMILY}" == "debian" && -z "${OS_VERSION_CODENAME}" ]]; then
    if command -v lsb_release >/dev/null 2>&1; then
      OS_VERSION_CODENAME=$(lsb_release -cs)
    fi
  fi
}

has_cmd() { command -v "$1" >/dev/null 2>&1; }

pkg_missing_apt() {
  dpkg -s "$1" >/dev/null 2>&1 || return 0
  return 1
}

pkg_missing_rpm() {
  rpm -q "$1" >/dev/null 2>&1 || return 0
  return 1
}

install_packages_apt() {
  local pkgs=($@)
  local missing=()
  for pkg in "${pkgs[@]}"; do
    if pkg_missing_apt "${pkg}"; then
      missing+=("${pkg}")
    fi
  done
  if [[ ${#missing[@]} -eq 0 ]]; then
    SKIPPED_ITEMS+=("apt packages (${pkgs[*]})")
    return 0
  fi
  ${SUDO} apt-get update -y
  ${SUDO} apt-get install -y "${missing[@]}"
  INSTALLED_ITEMS+=("apt packages (${missing[*]})")
}

install_packages_dnf() {
  local pkgs=($@)
  local missing=()
  for pkg in "${pkgs[@]}"; do
    if pkg_missing_rpm "${pkg}"; then
      missing+=("${pkg}")
    fi
  done
  if [[ ${#missing[@]} -eq 0 ]]; then
    SKIPPED_ITEMS+=("dnf packages (${pkgs[*]})")
    return 0
  fi
  ${SUDO} dnf install -y "${missing[@]}"
  INSTALLED_ITEMS+=("dnf packages (${missing[*]})")
}

ensure_kvm_modules() {
  if ! grep -E -q '(vmx|svm)' /proc/cpuinfo; then
    WARNINGS+=("CPU virtualization flags not detected (vmx/svm)")
    return 0
  fi

  if [[ -e /dev/kvm ]]; then
    return 0
  fi

  if [[ -r /proc/cpuinfo ]] && grep -qi "GenuineIntel" /proc/cpuinfo; then
    ${SUDO} modprobe kvm || true
    ${SUDO} modprobe kvm_intel || true
  else
    ${SUDO} modprobe kvm || true
    ${SUDO} modprobe kvm_amd || true
  fi

  if [[ ! -e /dev/kvm ]]; then
    WARNINGS+=("/dev/kvm still missing after modprobe")
  fi
}

ensure_group_membership() {
  local group=$1
  local user=$2
  if ! getent group "${group}" >/dev/null 2>&1; then
    WARNINGS+=("group '${group}' not found")
    return 0
  fi
  if id -nG "${user}" | grep -qw "${group}"; then
    return 0
  fi
  ${SUDO} usermod -aG "${group}" "${user}"
  WARNINGS+=("User '${user}' added to '${group}' group. Re-login required.")
}

ensure_docker_repo_debian() {
  local arch
  arch=$(dpkg --print-architecture)
  ${SUDO} install -m 0755 -d /etc/apt/keyrings
  ${SUDO} rm -f /etc/apt/keyrings/docker.gpg
  curl -fsSL "https://download.docker.com/linux/${OS_ID}/gpg" | ${SUDO} gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  ${SUDO} chmod a+r /etc/apt/keyrings/docker.gpg

  if [[ -z "${OS_VERSION_CODENAME}" ]]; then
    die "Could not determine OS codename for Docker repo."
  fi
  printf "deb [arch=%s signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/%s %s stable\n" "${arch}" "${OS_ID}" "${OS_VERSION_CODENAME}" | ${SUDO} tee /etc/apt/sources.list.d/docker.list >/dev/null
  ${SUDO} apt-get update -y
}

ensure_docker_repo_rhel() {
  local repo_os="${OS_ID}"
  case "${OS_ID}" in
    rocky|almalinux|centos)
      repo_os="centos"
      ;;
  esac
  ${SUDO} dnf -y install dnf-plugins-core
  ${SUDO} dnf config-manager --add-repo "https://download.docker.com/linux/${repo_os}/docker-ce.repo"
}

ensure_docker() {
  if has_cmd docker; then
    SKIPPED_ITEMS+=("docker (already installed)")
    return 0
  fi
  if [[ "${BOOTSTRAP_INSTALL_DOCKER}" != "1" ]]; then
    SKIPPED_ITEMS+=("docker (BOOTSTRAP_INSTALL_DOCKER=0)")
    return 0
  fi

  if [[ "${OS_FAMILY}" == "debian" ]]; then
    install_packages_apt ca-certificates curl gnupg
    ensure_docker_repo_debian
    install_packages_apt docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  else
    ensure_docker_repo_rhel
    install_packages_dnf docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  fi

  if command -v systemctl >/dev/null 2>&1; then
    ${SUDO} systemctl enable --now docker
  else
    WARNINGS+=("systemctl not found; start docker manually")
  fi

  ensure_group_membership docker "${USER}"
  INSTALLED_ITEMS+=("docker engine")
}

ensure_tofu_repo_debian() {
  ${SUDO} install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://get.opentofu.org/opentofu.gpg | ${SUDO} tee /etc/apt/keyrings/opentofu.gpg >/dev/null
  curl -fsSL https://packages.opentofu.org/opentofu/tofu/gpgkey | ${SUDO} gpg --no-tty --batch --dearmor -o /etc/apt/keyrings/opentofu-repo.gpg >/dev/null
  ${SUDO} chmod a+r /etc/apt/keyrings/opentofu.gpg /etc/apt/keyrings/opentofu-repo.gpg
  printf "deb [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main\n" | \
    ${SUDO} tee /etc/apt/sources.list.d/opentofu.list >/dev/null
  ${SUDO} apt-get update -y
}

ensure_tofu_repo_rhel() {
  ${SUDO} tee /etc/yum.repos.d/opentofu.repo >/dev/null <<'REPO'
[opentofu]
name=opentofu
baseurl=https://packages.opentofu.org/opentofu/tofu/rpm_any/rpm_any/$basearch
repo_gpgcheck=0
gpgcheck=1
enabled=1
gpgkey=https://get.opentofu.org/opentofu.gpg
       https://packages.opentofu.org/opentofu/tofu/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
[opentofu-source]
name=opentofu-source
baseurl=https://packages.opentofu.org/opentofu/tofu/rpm_any/rpm_any/SRPMS
repo_gpgcheck=0
gpgcheck=1
enabled=1
gpgkey=https://get.opentofu.org/opentofu.gpg
       https://packages.opentofu.org/opentofu/tofu/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
REPO
}

ensure_tofu() {
  if has_cmd tofu; then
    SKIPPED_ITEMS+=("tofu (already installed)")
    return 0
  fi
  if [[ "${BOOTSTRAP_INSTALL_TOFU}" != "1" ]]; then
    SKIPPED_ITEMS+=("tofu (BOOTSTRAP_INSTALL_TOFU=0)")
    return 0
  fi

  if [[ "${OS_FAMILY}" == "debian" ]]; then
    install_packages_apt ca-certificates curl gnupg
    ensure_tofu_repo_debian
    install_packages_apt tofu
  else
    if [[ "${OS_ID}" == "fedora" ]]; then
      install_packages_dnf opentofu
    else
      ensure_tofu_repo_rhel
      install_packages_dnf tofu
    fi
  fi
  INSTALLED_ITEMS+=("tofu")
}

install_tooling() {
  if [[ "${OS_FAMILY}" == "debian" ]]; then
    install_packages_apt make git curl wget jq openssh-client rsync python3 python3-venv python3-pip
    if [[ "${BOOTSTRAP_INSTALL_NETTOOLS}" == "1" ]]; then
      install_packages_apt iproute2 bridge-utils iptables nftables
    fi
    if [[ "${BOOTSTRAP_INSTALL_QEMU}" == "1" ]]; then
      install_packages_apt qemu-system-x86 qemu-utils ovmf
    fi
    if [[ "${BOOTSTRAP_INSTALL_CLOUDTOOLS}" == "1" ]]; then
      install_packages_apt cloud-image-utils || install_packages_apt genisoimage xorriso
    fi
    if [[ "${BOOTSTRAP_INSTALL_LIBVIRT}" == "1" ]]; then
      install_packages_apt libvirt-daemon-system libvirt-clients virtinst qemu-kvm
    fi
    if [[ "${BOOTSTRAP_INSTALL_ANSIBLE}" == "1" ]]; then
      install_packages_apt ansible
    fi
  else
    install_packages_dnf make git curl wget jq openssh-clients rsync python3 python3-pip
    if [[ "${BOOTSTRAP_INSTALL_NETTOOLS}" == "1" ]]; then
      install_packages_dnf iproute bridge-utils iptables nftables
    fi
    if [[ "${BOOTSTRAP_INSTALL_QEMU}" == "1" ]]; then
      install_packages_dnf qemu-kvm qemu-img edk2-ovmf
    fi
    if [[ "${BOOTSTRAP_INSTALL_CLOUDTOOLS}" == "1" ]]; then
      install_packages_dnf cloud-utils genisoimage xorriso
    fi
    if [[ "${BOOTSTRAP_INSTALL_LIBVIRT}" == "1" ]]; then
      install_packages_dnf libvirt libvirt-daemon libvirt-client virt-install
    fi
    if [[ "${BOOTSTRAP_INSTALL_ANSIBLE}" == "1" ]]; then
      install_packages_dnf ansible-core
    fi
  fi
}

verify_access() {
  if [[ -e /dev/kvm ]]; then
    if [[ -r /dev/kvm && -w /dev/kvm ]]; then
      return 0
    fi
    WARNINGS+=("/dev/kvm exists but current user lacks read/write access")
  else
    WARNINGS+=("/dev/kvm not found")
  fi
}

print_summary() {
  printf "\n%s\n" "=== Bootstrap Summary ==="
  if [[ ${#INSTALLED_ITEMS[@]} -gt 0 ]]; then
    printf "%s\n" "Installed:"; printf -- "- %s\n" "${INSTALLED_ITEMS[@]}"
  fi
  if [[ ${#SKIPPED_ITEMS[@]} -gt 0 ]]; then
    printf "%s\n" "Skipped:"; printf -- "- %s\n" "${SKIPPED_ITEMS[@]}"
  fi
  if [[ ${#WARNINGS[@]} -gt 0 ]]; then
    printf "%s\n" "Warnings:"; printf -- "- %s\n" "${WARNINGS[@]}"
  fi
  printf "\n%s\n" "Next steps:"
  printf -- "- %s\n" "If groups changed, log out/in to apply docker/kvm access."
  printf -- "- %s\n" "Run: make prereqs-check"
  printf "\n%s\n" "Quick verification:"
  printf -- "- %s\n" "docker --version"
  printf -- "- %s\n" "qemu-system-x86_64 --version"
  printf -- "- %s\n" "[ -r /dev/kvm ] && [ -w /dev/kvm ]"
}

main() {
  detect_distro
  require_sudo

  log "Detected OS: ${OS_ID} (${OS_FAMILY})"
  confirm_or_exit

  install_tooling
  ensure_tofu
  ensure_docker
  ensure_kvm_modules
  verify_access

  if [[ "${BOOTSTRAP_INSTALL_LIBVIRT}" == "1" ]]; then
    if command -v systemctl >/dev/null 2>&1; then
      ${SUDO} systemctl enable --now libvirtd || ${SUDO} systemctl enable --now libvirt-daemon || true
    fi
    ensure_group_membership libvirt "${USER}"
    ensure_group_membership kvm "${USER}"
  fi

  print_summary
}

main "$@"
