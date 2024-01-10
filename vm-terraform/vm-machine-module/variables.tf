variable "vm_name" {
  description = "Name for VM"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name to hold VM"
  type        = string
}

variable "location" {
  description = "Location to hold resource group and VM"
  type        = string
}

variable "network_interface_id" {
  description = "ID for network interface from networking module"
  type        = string
}

variable "admin_username" {
  description = "Admin username for VM"
  type        = string
}

variable "admin_password" {
  description = "Password for VM"
  type        = string
}
