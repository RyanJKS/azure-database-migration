variable "resource_group_name" {
  description = "Resource Group name to hold VM"
  type        = string
}

variable "location" {
  description = "Location for resource group and VM"
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

variable "unique_server_name" {
  description = "A unique name for the SQL Server instance."
  type        = string
}

variable "prod_vm_public_ip" {
  description = "The public IP address assigned to the Production Virtual Machine."
  type        = string
}
variable "dev_vm_public_ip" {
  description = "The public IP address assigned to the Development Virtual Machine."
  type        = string
}
