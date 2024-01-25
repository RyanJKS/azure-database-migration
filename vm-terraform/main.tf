terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.1"
    }
  }
}

provider "azurerm" {
  features {}
  client_id       = var.client_id     # Service Principal Client ID
  client_secret   = var.client_secret # Service Principal Client Secret
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

module "networking" {
  source = "./vm-networking"

  resource_group_name = "migration-rg-${var.admin_username}"
  location            = "UK South"
  my_public_ip        = var.my_public_ip # IP Address to connect to VM
}

module "production-vm" {
  source = "./vm-module"

  vm_name             = "production-vm"
  resource_group_name = module.networking.network_resource_group_name
  location            = module.networking.network_location
  subnet_id           = module.networking.subnet_id
  nsg_id              = module.networking.nsg_id
  admin_username      = var.admin_username
  admin_password      = var.admin_password
}
module "development-vm" {
  source = "./vm-module"

  vm_name             = "development-vm"
  resource_group_name = module.networking.network_resource_group_name
  location            = module.networking.network_location
  subnet_id           = module.networking.subnet_id
  nsg_id              = module.networking.nsg_id
  admin_username      = var.admin_username
  admin_password      = var.admin_password
}


resource "time_sleep" "wait_60_seconds" {
  depends_on = [module.production-vm, module.development-vm]

  create_duration = "60s"
}

module "sql-server-module" {
  source = "./sql-server-module"

  unique_server_name  = "production-server-${var.admin_username}"
  resource_group_name = module.networking.network_resource_group_name
  location            = module.networking.network_location
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  prod_vm_public_ip   = module.production-vm.vm_public_ip_address
  dev_vm_public_ip    = module.development-vm.vm_public_ip_address
  depends_on          = [time_sleep.wait_60_seconds]
}


