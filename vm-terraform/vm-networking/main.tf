resource "azurerm_resource_group" "db_migration_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vm_network" {
  name                = "db-migration-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.db_migration_rg.location
  resource_group_name = azurerm_resource_group.db_migration_rg.name
}

resource "azurerm_subnet" "vm_network_subnet" {
  name                 = "db-migration-network-subnet"
  resource_group_name  = azurerm_resource_group.db_migration_rg.name
  virtual_network_name = azurerm_virtual_network.vm_network.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Define the public IP address resource
resource "azurerm_public_ip" "vm_public_ip" {
  name                = "db-migration-public-ip"
  location            = azurerm_resource_group.db_migration_rg.location
  resource_group_name = azurerm_resource_group.db_migration_rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "vm_network_interface" {
  name                = "db-migration-network-interface"
  location            = azurerm_resource_group.db_migration_rg.location
  resource_group_name = azurerm_resource_group.db_migration_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_network_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id # Associate public IP
  }
}

resource "azurerm_network_security_group" "vm_nsg" {
  name                = "db-migration-nsg"
  location            = azurerm_resource_group.db_migration_rg.location
  resource_group_name = azurerm_resource_group.db_migration_rg.name

  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = var.my_public_ip
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "vm_nic_nsg_association" {
  network_interface_id      = azurerm_network_interface.vm_network_interface.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}
