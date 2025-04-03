variable "location" {
  description = "Location"
}

variable "resource_group_name" {
  description = "Resource group name"
}

variable "prefix" {
  description = "Resource prefix name"
}

variable "virtual_network_id" {
    description = "Virtual network id"
}

variable "virtual_network_name" {
    description = "Virtual network name"
}

variable "address_prefixes" {
  description = "Subnetwork address prefixes"
}

variable "db_private_dns_name" {
  description = "Private DNS zone name for PostgreSQL server"
}

