resource "azurerm_subnet" "postgres_subnet" {
  name                 = "postgres-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.address_prefixes
  service_endpoints    = ["Microsoft.Storage"]

  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

resource "random_password" "postgres_password" {
  length  = 16
  special = false
}

resource "azurerm_private_dns_zone" "pg_dns" {
  name                = var.db_private_dns_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "pg_dns_link" {
  name                  = "pg-vnet-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.pg_dns.name
  virtual_network_id    = var.virtual_network_id

  depends_on = [ azurerm_subnet.postgres_subnet ]
}

resource "azurerm_postgresql_flexible_server" "server" {
  name                          = "${var.prefix}-postgresql-server"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  delegated_subnet_id           = azurerm_subnet.postgres_subnet.id
  private_dns_zone_id           = azurerm_private_dns_zone.pg_dns.id
  public_network_access_enabled = false
  administrator_login           = local.administrator_login
  administrator_password        = random_password.postgres_password.result
  storage_mb = 32768
  # storage_tier = "P4"
  zone = "1"
  version    = "14"
  sku_name   = "GP_Standard_D2s_v3"

  depends_on = [azurerm_private_dns_zone_virtual_network_link.pg_dns_link]
}



