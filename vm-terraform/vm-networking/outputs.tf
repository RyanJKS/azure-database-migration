output "network_resource_group_name" {
  description = "Name for resource group"
  value       = azurerm_resource_group.db_migration_rg.name
}

output "network_location" {
  description = "Network location"
  value       = azurerm_resource_group.db_migration_rg.location
}

# Output for the Subnet ID
output "subnet_id" {
  description = "The ID of the subnet in the virtual network"
  value       = azurerm_subnet.vm_network_subnet.id
}

# Output for the Network Security Group ID
output "nsg_id" {
  description = "The ID of the Network Security Group"
  value       = azurerm_network_security_group.vm_nsg.id
}
