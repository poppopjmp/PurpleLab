variable "vsphere_user" {
  description = "vSphere user"
}

variable "vsphere_password" {
  description = "vSphere password"
  sensitive   = true
}

variable "vsphere_server" {
  description = "vSphere server"
}

variable "vsphere_datacenter" {
  description = "vSphere datacenter"
}

variable "vsphere_datastore" {
  description = "vSphere datastore"
}

variable "vsphere_compute_cluster" {
  description = "vSphere compute cluster"
}

variable "vsphere_network" {
  description = "vSphere network"
}

variable "vsphere_template" {
  description = "vSphere template"
}

variable "vm_count" {
  description = "Number of VMs to create"
  default     = 1
}

variable "vm_name_prefix" {
  description = "Prefix for VM names"
  default     = "vm"
}

variable "vm_num_cpus" {
  description = "Number of CPUs for each VM"
  default     = 2
}

variable "vm_memory" {
  description = "Memory for each VM in MB"
  default     = 4096
}

variable "vm_domain" {
  description = "Domain for VMs"
  default     = "local"
}

variable "vm_ip_addresses" {
  description = "List of IP addresses for VMs"
  type        = list(string)
}

variable "vm_netmask" {
  description = "Netmask for VMs"
  default     = 24
}

variable "vm_gateway" {
  description = "Gateway for VMs"
}
