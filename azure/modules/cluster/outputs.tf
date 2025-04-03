output "id" {
    description = "K8s cluster id"
    value = azurerm_kubernetes_cluster.my-cluster.id
}

output "kube_config" {
    description = "K8s cluster kube config"
    value = azurerm_kubernetes_cluster.my-cluster.kube_config
}

output "host" {
    description = "K8s cluster id"
    value = azurerm_kubernetes_cluster.my-cluster.kube_config[0].host
}

output "aks_node_resource_group" {
    description = "Auto-generated Resource Group containing AKS Cluster resources"
    value = azurerm_kubernetes_cluster.my-cluster.node_resource_group
}

output "aks_identity_principal_id" {
    description = "AKS managed identity principal id"
    value = azurerm_user_assigned_identity.aks_identity.principal_id
}
