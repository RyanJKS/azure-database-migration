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

variable "admin_username" {
  description = "Admin username for VM"
  type        = string
}

variable "admin_password" {
  description = "Password for VM"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet where the VM will be connected"
  type        = string
}

# Variable for the Network Security Group (NSG) ID
variable "nsg_id" {
  description = "The ID of the Network Security Group associated with the VM"
  type        = string
}
