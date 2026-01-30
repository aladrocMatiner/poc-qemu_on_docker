terraform {
  required_providers {
    libvirt = {
      source  = "registry.terraform.io/dmacvicar/libvirt"
      version = "~> 0.7.2"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}
