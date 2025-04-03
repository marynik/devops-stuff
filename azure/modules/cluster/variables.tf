variable "location" {
  description = "Location"
}

variable "resource_group_name" {
  description = "Resource group name"
}

variable "prefix" {
  description = "Resource prefix name"
}

variable "virtual_network_name" {
    description = "Virtual network name"
}

variable "pod_cidr" {
  description = "AKS subnetwork address prefixes"
}

variable "service_cidr" {
  description = "AKS service address prefixes"
}

variable "dns_service_ip" {
  description = "CoreDNS ip-address"
}

variable "node_count" {
  default     = 2
  description = "Number of nodes"
}

variable "vm_size" {
  description = "Machine type for nodes"
}
