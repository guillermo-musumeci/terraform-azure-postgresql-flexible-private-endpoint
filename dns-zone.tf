#####################
## DNS - Resources ##
#####################

# Reference to Private DNS Zone for PostgreSQL
data "azurerm_private_dns_zone" "postgres_dns_zone" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.private_dns_resource_group
}
