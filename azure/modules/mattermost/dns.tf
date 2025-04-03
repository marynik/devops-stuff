resource "azurerm_dns_a_record" "mattermost" {
  name                = "mattermost"
  zone_name           = var.dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = 300

  records = [ data.kubernetes_service.ingress-nginx.status[0].load_balancer[0].ingress[0].ip ]
}
