# Resource to create an Azure SQL Server instance for production
resource "azurerm_mssql_server" "production_server" {
  name                         = var.unique_server_name # Unique name for the SQL server instance
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.admin_username # Admin username for SQL Server
  administrator_login_password = var.admin_password # Admin password for SQL Server
  minimum_tls_version          = "1.2"              # Minimum TLS version for enhanced security

  tags = {
    environment = "production"
  }
}

# Resource to create a firewall rule for the production SQL Server to allow traffic from the Production VM's public IP
resource "azurerm_mssql_firewall_rule" "allow_prod_vm_ip" {
  name             = "AllowProdVMIP"
  server_id        = azurerm_mssql_server.production_server.id # Reference to the created SQL Server
  start_ip_address = var.prod_vm_public_ip                     # Start IP address for the firewall rule
  end_ip_address   = var.prod_vm_public_ip                     # End IP address (same as start, for a single IP)
}

# Resource to create a firewall rule for the production SQL Server to allow traffic from the Development VM's public IP
resource "azurerm_mssql_firewall_rule" "allow_dev_vm_ip" {
  name             = "AllowDevVMIP"
  server_id        = azurerm_mssql_server.production_server.id # Reference to the created SQL Server
  start_ip_address = var.dev_vm_public_ip                      # Start IP address for the firewall rule
  end_ip_address   = var.dev_vm_public_ip                      # End IP address (same as start, for a single IP)
}

# Resource to create an Azure Storage Account for production use
resource "azurerm_storage_account" "production_storage_account" {
  name                     = "prodstorage${var.admin_username}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Resource to create a SQL database within the Azure SQL Server
resource "azurerm_mssql_database" "production_database" {
  name      = "database${var.admin_username}"
  server_id = azurerm_mssql_server.production_server.id # Reference to the created SQL Server

  tags = {
    environment = "production"
  }
}
