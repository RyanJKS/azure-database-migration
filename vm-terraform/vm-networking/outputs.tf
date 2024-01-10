output "network_resource_group_name" {
  description = "Name for resource group"
  value       = azurerm_resource_group.db_migration_rg.name
}

output "network_location" {
  description = "Network location"
  value       = azurerm_resource_group.db_migration_rg.location
}

output "network_interface_id" {
  description = "Network Interface ID"
  value       = azurerm_network_interface.vm_network_interface.id
}
