variable "lab_name" {
  type        = string
  description = "Lab name prefix for VM naming"
}

variable "lab_nodes" {
  type        = number
  description = "Number of lab nodes"
}

variable "vm_cpu" {
  type        = number
  description = "vCPU count per VM"
}

variable "vm_ram_mb" {
  type        = number
  description = "Memory per VM (MB)"
}

variable "vm_disk_gb" {
  type        = number
  description = "Disk size per VM (GB)"
}

variable "mgmt_mode" {
  type        = string
  description = "Management mode: user or bridge"
}

variable "mgmt_bridge" {
  type        = string
  description = "Host bridge name for management NIC (bridge mode)"
  default     = ""
}

variable "mgmt_network" {
  type        = string
  description = "Libvirt network name for MGMT_MODE=user"
  default     = "default"
}

variable "swarm_bridge" {
  type        = string
  description = "Host bridge name for swarm NIC"
}

variable "mac_prefix" {
  type        = string
  description = "MAC prefix (first 5 octets)"
}

variable "mac_offset_mgmt" {
  type        = number
  description = "Offset for mgmt MAC last octet"
  default     = 16
}

variable "mac_offset_swarm" {
  type        = number
  description = "Offset for swarm MAC last octet"
  default     = 32
}

variable "ssh_user" {
  type        = string
  description = "SSH username for cloud-init"
}

variable "ssh_pubkey_path" {
  type        = string
  description = "Path to SSH public key"
}

variable "base_image_name" {
  type        = string
  description = "Base image filename"
}

variable "downloads_dir" {
  type        = string
  description = "Directory where base images are stored"
}

variable "pool_path" {
  type        = string
  description = "Libvirt storage pool path"
}

variable "libvirt_uri" {
  type        = string
  description = "Libvirt URI"
  default     = "qemu:///system"
}
