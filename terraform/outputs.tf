output "vm_ips" {
  description = "The IP addresses of the VMs"
  value       = vsphere_virtual_machine.vm.*.network_interface.0.ipv4_address
}

output "vm_states" {
  description = "The power states of the VMs"
  value       = vsphere_virtual_machine.vm.*.power_state
}
