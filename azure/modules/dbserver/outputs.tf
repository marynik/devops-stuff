output "id" {
    description = "Database server id"
    value = azurerm_postgresql_flexible_server.server.id
}

output "host" {
    description = "Database server fqdn"
    value = azurerm_postgresql_flexible_server.server.fqdn
}

output "admin_login" {
    description = "Database server administrator login"
    value = azurerm_postgresql_flexible_server.server.administrator_login
}

output "admin_password" {
    description = "Database server administrator password"
    value = azurerm_postgresql_flexible_server.server.administrator_password
    sensitive = true
}
