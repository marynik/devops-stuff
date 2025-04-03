output "dns_zone_id" {
    description = "Azure dns zone id"
    value = azurerm_dns_zone.azure_zone.id
}

output "dns_zone_name" {
  description = "Azure dns zone name"
  value = azurerm_dns_zone.azure_zone.name
}

output "dns_ns_names" {
  description = "List of azure nameservers"
  value = azurerm_dns_zone.azure_zone.name_servers
}
