# Resource to create a public IP for the VM
resource "azurerm_public_ip" "vm_public_ip" {
  name                = "${var.vm_name}-public-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"
}

# Resource to create a network interface for the VM
resource "azurerm_network_interface" "vm_network_interface" {
  name                = "${var.vm_name}-network-interface"
  resource_group_name = azurerm_public_ip.vm_public_ip.resource_group_name
  location            = azurerm_public_ip.vm_public_ip.location

  # Configuration for the network interface
  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id # Associates the public IP with the network interface
  }
}

# Resource to associate the network interface with a network security group
resource "azurerm_network_interface_security_group_association" "vm_nic_nsg_association" {
  network_interface_id      = azurerm_network_interface.vm_network_interface.id # Network interface ID
  network_security_group_id = var.nsg_id                                        # Network security group ID
}

# Resource to create a Windows virtual machine
resource "azurerm_windows_virtual_machine" "vm-windows" {
  name                  = var.vm_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = "Standard_B2s"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.vm_network_interface.id] # Associates the network interface with the VM

  # Configuration for the OS disk
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Configuration for the source image of the VM
  source_image_reference {
    publisher = "microsoftwindowsdesktop"
    offer     = "windows-11"
    sku       = "win11-22h2-pro"
    version   = "latest"
  }
}

# Resource to apply a custom script extension to the VM
resource "azurerm_virtual_machine_extension" "vm_custom_script" {
  name                 = "installSQL" # Name of the extension
  virtual_machine_id   = azurerm_windows_virtual_machine.vm-windows.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  # Configuration for the custom script, including the command to execute
  protected_settings = <<SETTINGS
  {
    "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.install_script.rendered)}')) | Out-File -filepath install.ps1\" && powershell -ExecutionPolicy Unrestricted -File install.ps1"
  }
  SETTINGS
}

# Data source for the custom script template
data "template_file" "install_script" {
  template = file("${path.module}/Install-SQLServer.ps1") # Path to the script file
}
