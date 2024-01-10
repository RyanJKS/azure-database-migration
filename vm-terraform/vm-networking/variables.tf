variable "resource_group_name" {
  description = "Name of the resource group that will have the VM"
  type        = string
}

variable "location" {
  description = "Location for resource group and VM"
  type        = string
}

variable "my_public_ip" {
  description = "My public IP address for RDP access"
  type        = string
}
