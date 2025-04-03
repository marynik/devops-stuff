output "id" {
    description = "Virtual network id"
    value = azurerm_virtual_network.vnet.id
}
output "name" {
    description = "Virtual network name"
    value = azurerm_virtual_network.vnet.name
}
