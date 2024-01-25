# Output for the Virtual Machine's Public IP Address
output "vm_public_ip_address" {
  description = "The Public IP Address assigned to the Virtual Machine"
  value       = azurerm_public_ip.vm_public_ip.ip_address
}
