resource "azurerm_resource_group" "db_migration_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vm_network" {
  name                = "vm-network"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.db_migration_rg.name
  location            = azurerm_resource_group.db_migration_rg.location
}

resource "azurerm_subnet" "vm_network_subnet" {
  name                 = "vm-network-subnet"
  resource_group_name  = azurerm_resource_group.db_migration_rg.name
  virtual_network_name = azurerm_virtual_network.vm_network.name
  address_prefixes     = ["10.0.2.0/24"]
}


resource "azurerm_network_security_group" "vm_nsg" {
  name                = "vm-nsg"
  resource_group_name = azurerm_resource_group.db_migration_rg.name
  location            = azurerm_resource_group.db_migration_rg.location

  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = var.my_public_ip # Restrict source IP for security
    destination_address_prefix = "*"              # Apply to all destinations
  }
}

