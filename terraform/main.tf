provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_compute_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vsphere_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  count            = var.vm_count
  name             = "${var.vm_name_prefix}-${count.index}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.vm_num_cpus
  memory   = var.vm_memory
  guest_id = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = false
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "${var.vm_name_prefix}-${count.index}"
        domain    = var.vm_domain
      }

      network_interface {
        ipv4_address = element(var.vm_ip_addresses, count.index)
        ipv4_netmask = var.vm_netmask
      }

      ipv4_gateway = var.vm_gateway
    }
  }
}

output "vm_ips" {
  value = vsphere_virtual_machine.vm.*.network_interface.0.ipv4_address
}

output "vm_states" {
  value = vsphere_virtual_machine.vm.*.power_state
}

variable "vsphere_user" {}
variable "vsphere_password" {}
variable "vsphere_server" {}
variable "vsphere_datacenter" {}
variable "vsphere_datastore" {}
variable "vsphere_compute_cluster" {}
variable "vsphere_network" {}
variable "vsphere_template" {}
variable "vm_count" {
  default = 1
}
variable "vm_name_prefix" {
  default = "vm"
}
variable "vm_num_cpus" {
  default = 2
}
variable "vm_memory" {
  default = 4096
}
variable "vm_domain" {
  default = "local"
}
variable "vm_ip_addresses" {
  type = list(string)
}
variable "vm_netmask" {
  default = 24
}
variable "vm_gateway" {}
