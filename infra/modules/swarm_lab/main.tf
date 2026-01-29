locals {
  base_image_path = "${var.downloads_dir}/${var.base_image_name}"
  nodes = [for i in range(var.lab_nodes) : {
    index     = i + 1
    name      = "${var.lab_name}-node${i + 1}"
    mgmt_mac  = format("%s:%02x", var.mac_prefix, var.mac_offset_mgmt + i + 1)
    swarm_mac = format("%s:%02x", var.mac_prefix, var.mac_offset_swarm + i + 1)
  }]
}

resource "libvirt_pool" "lab" {
  name = "${var.lab_name}-pool"
  type = "dir"
  path = var.pool_path
}

resource "libvirt_volume" "base" {
  name   = "${var.lab_name}-base-${var.base_image_name}"
  pool   = libvirt_pool.lab.name
  source = local.base_image_path
  format = "qcow2"
}

resource "libvirt_volume" "disk" {
  count          = var.lab_nodes
  name           = "${var.lab_name}-node${count.index + 1}.qcow2"
  pool           = libvirt_pool.lab.name
  base_volume_id = libvirt_volume.base.id
  size           = var.vm_disk_gb * 1024 * 1024 * 1024
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  count     = var.lab_nodes
  name      = "${var.lab_name}-node${count.index + 1}-seed.iso"
  pool      = libvirt_pool.lab.name
  user_data = templatefile("${path.module}/cloudinit/user-data.yaml.tftpl", {
    ssh_user        = var.ssh_user
    ssh_pubkey      = file(var.ssh_pubkey_path)
    hostname        = "${var.lab_name}-node${count.index + 1}"
  })
  meta_data = templatefile("${path.module}/cloudinit/meta-data.yaml.tftpl", {
    instance_id = "${var.lab_name}-node${count.index + 1}"
    hostname    = "${var.lab_name}-node${count.index + 1}"
  })
}

resource "libvirt_domain" "node" {
  count  = var.lab_nodes
  name   = "${var.lab_name}-node${count.index + 1}"
  vcpu   = var.vm_cpu
  memory = var.vm_ram_mb

  disk {
    volume_id = libvirt_volume.disk[count.index].id
  }

  cloudinit = libvirt_cloudinit_disk.cloudinit[count.index].id

  network_interface {
    mac = local.nodes[count.index].mgmt_mac
    network_name = var.mgmt_mode == "user" ? var.mgmt_network : null
    bridge       = var.mgmt_mode == "bridge" ? var.mgmt_bridge : null
  }

  network_interface {
    mac    = local.nodes[count.index].swarm_mac
    bridge = var.swarm_bridge
  }
}
