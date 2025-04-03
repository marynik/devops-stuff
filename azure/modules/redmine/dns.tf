resource "azurerm_public_ip" "redmine_ip" {
  name                = "remine-public-ip"
  location            = var.location
  resource_group_name = var.aks_resource_group_name
  allocation_method   = "Static"
  ip_version          = "IPv4"
}

resource "azurerm_dns_a_record" "redmine" {
  name                = "redmine"
  zone_name           = var.dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  target_resource_id = azurerm_public_ip.redmine_ip.id
}
