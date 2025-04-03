variable "location" {
  description = "Location"
}

variable "resource_group_name" {
  description = "Resource group name"
}

variable "aks_resource_group_name" {
  description = "K8s auto-generated resource group name"
}

variable "virtual_network_name" {
    description = "Virtual network name"
}

variable "dbserver_id" {
    description = "Database server id"
}

variable "dbserver_host" {
    description = "Database server host"
}

variable "dbserver_admin_login" {
    description = "Database server admin login"
}

variable "dbserver_admin_password" {
    description = "Database server admin password"
}

variable "domain" {
    description = "Mattermost domain"
}

variable "dns_zone_name" {
    description = "Mattermost dns zone name"
}

variable "aks_identity_principal_id" {
    description = "AKS managed identity principal id"
}
