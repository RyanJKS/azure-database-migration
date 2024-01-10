terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}


module "networking" {
  source = "./vm-networking"

  resource_group_name = "db-migration-resource"
  location            = "UK South"
  my_public_ip        = var.my_public_ip
}

module "vm-module" {
  source = "./vm-machine-module"

  vm_name              = "db-migration-vm"
  resource_group_name  = module.networking.network_resource_group_name
  location             = module.networking.network_location
  admin_username       = var.admin_username
  admin_password       = var.admin_password
  network_interface_id = module.networking.network_interface_id
}
