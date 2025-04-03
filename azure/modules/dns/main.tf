resource "azurerm_dns_zone" "azure_zone" {
    name = var.dns_zone
    resource_group_name = var.resource_group_name
}


# resource "google_dns_managed_zone" "gcp_zone" {
#   name        = "gcp-zone"
#   dns_name    = "${var.domain}."
#   description = "GCP DNS zone for my domains"
#   visibility  = "public"
#   # force_destroy = true
# }
