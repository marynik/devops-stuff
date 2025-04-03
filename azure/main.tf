
module "network" {
  source              = "./modules/network"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

module "cluster" {
  source               = "./modules/cluster"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  prefix               = var.prefix
  pod_cidr             = ["10.0.1.0/24"]
  service_cidr         = "10.1.0.0/16"
  dns_service_ip       = "10.1.0.10"
  virtual_network_name = module.network.name
  node_count           = 2
  vm_size              = "Standard_DS2_v2"
}

module "dbserver" {
  source               = "./modules/dbserver"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  prefix               = var.prefix
  address_prefixes     = ["10.0.2.0/24"]
  virtual_network_id   = module.network.id
  virtual_network_name = module.network.name
  db_private_dns_name  = "privatelink.postgres.database.azure.com"
}

module "dns" {
  source = "./modules/dns"
  resource_group_name = azurerm_resource_group.rg.name
  dns_zone = var.domain
}

module "redmine" {
  source                  = "./modules/redmine"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  aks_resource_group_name = module.cluster.aks_node_resource_group
  virtual_network_name    = module.network.name
  dbserver_id             = module.dbserver.id
  dbserver_host           = module.dbserver.host
  dbserver_admin_login    = module.dbserver.admin_login
  dbserver_admin_password = module.dbserver.admin_password
  domain = "redmine.${var.domain}"
  dns_zone_name = module.dns.dns_zone_name
}

module "mattermost" {
  source = "./modules/mattermost"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  aks_resource_group_name = module.cluster.aks_node_resource_group
  virtual_network_name    = module.network.name
  dbserver_id             = module.dbserver.id
  dbserver_host           = module.dbserver.host
  dbserver_admin_login    = module.dbserver.admin_login
  dbserver_admin_password = module.dbserver.admin_password
  domain = "mattermost.${var.domain}"
  dns_zone_name = module.dns.dns_zone_name
  aks_identity_principal_id = module.cluster.aks_identity_principal_id
}
