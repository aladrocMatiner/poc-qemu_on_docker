module "swarm_lab" {
  source = "./modules/swarm_lab"

  lab_name          = var.lab_name
  lab_nodes         = var.lab_nodes
  vm_cpu            = var.vm_cpu
  vm_ram_mb         = var.vm_ram_mb
  vm_disk_gb        = var.vm_disk_gb
  mgmt_mode         = var.mgmt_mode
  mgmt_bridge       = var.mgmt_bridge
  mgmt_network      = var.mgmt_network
  mgmt_network_cidr = var.mgmt_network_cidr
  mgmt_ip_start     = var.mgmt_ip_start
  swarm_bridge      = var.swarm_bridge
  mac_prefix        = var.mac_prefix
  mac_offset_mgmt   = var.mac_offset_mgmt
  mac_offset_swarm  = var.mac_offset_swarm
  ssh_user          = var.ssh_user
  ssh_pubkey_path   = var.ssh_pubkey_path
  base_image_name   = var.base_image_name
  downloads_dir     = var.downloads_dir
  pool_path         = var.pool_path
  libvirt_uri       = var.libvirt_uri
  libvirt_seclabel_mode = var.libvirt_seclabel_mode
}
