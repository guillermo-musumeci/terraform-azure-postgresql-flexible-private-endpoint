##############################################
## PostgresSQL Private Endpoint - Resources ##
##############################################

# Create Private DNS Zone Virtual Network Link for PostgreSQL
resource "azurerm_private_dns_zone_virtual_network_link" "pe" {
  name                  = "${lower(replace(var.company," ","-"))}-${var.app_name}-${var.environment}-pe-vnet-link"
  resource_group_name   = data.azurerm_private_dns_zone.postgres_dns_zone.resource_group_name
  private_dns_zone_name = data.azurerm_private_dns_zone.postgres_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.this.id

  depends_on = [ azurerm_subnet.pe, azurerm_virtual_network.this ]
}

# Create PostgreSQL Public Flexible Server
resource "azurerm_postgresql_flexible_server" "pe" {
  name                = "${lower(replace(var.company," ","-"))}-${var.app_name}-${var.environment}-postgresql-pe"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  version  = var.postgres_server_version
  sku_name = var.postgres_server_sku
  
  public_network_access_enabled = false

  administrator_login    = var.postgres_user
  administrator_password = var.postgres_password
  
  storage_mb   = var.postgres_server_storage_mb
  storage_tier = var.postgres_server_storage_tier

  zone = 2

  tags = var.tags
}

# Create the Private Endpoint
resource "azurerm_private_endpoint" "pe" {
name                  = "${lower(replace(var.company," ","-"))}-${var.app_name}-${var.environment}-pe"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = azurerm_subnet.pe.id

  private_service_connection {
    name                           = "${lower(replace(var.company," ","-"))}-${var.app_name}-${var.environment}-psc"
    private_connection_resource_id = azurerm_postgresql_flexible_server.pe.id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = azurerm_postgresql_flexible_server.pe.name
    private_dns_zone_ids = [data.azurerm_private_dns_zone.postgres_dns_zone.id]
  }

  depends_on = [ azurerm_postgresql_flexible_server.pe, azurerm_subnet.pe ]
}

# Create PostgreSQL Database
resource "azurerm_postgresql_flexible_server_database" "pe" {
  name      = "${var.app_name}-${var.environment}-db-pe"
  server_id = azurerm_postgresql_flexible_server.pe.id
  charset   = var.postgres_database_charset
  collation = var.postgres_database_collation

  # To  prevent the possibility of accidental data loss change to true in production
  lifecycle {
    prevent_destroy = false
  }

  depends_on = [ azurerm_postgresql_flexible_server.pe ]
}  

# Create PostgreSQL Firewall Rule for Azure Services
resource "azurerm_postgresql_flexible_server_firewall_rule" "azure" {
  name             = "azure_services"
  server_id        = azurerm_postgresql_flexible_server.pe.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"

  depends_on = [ azurerm_postgresql_flexible_server.pe ]
}

# Create PostgreSQL Firewall Rule for everyone
resource "azurerm_postgresql_flexible_server_firewall_rule" "everyone" {
  name             = "everyone"
  server_id        = azurerm_postgresql_flexible_server.pe.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"

  depends_on = [ azurerm_postgresql_flexible_server.pe ]
}

# Enable PostgreSQL Extensions
resource "azurerm_postgresql_flexible_server_configuration" "extensions" {
  name      = "azure.extensions"
  server_id = azurerm_postgresql_flexible_server.pe.id
  value     = "VECTOR"
}

##########################################
## PostgresSQL Public Database - Output ##
##########################################

output "private_endpoint_postgresql_server_name" {
  value       = azurerm_postgresql_flexible_server.pe.name
  description = "The name of the PostgreSQL Server"
}

output "private_endpoint_postgresql_database_name" {
  value       = azurerm_postgresql_flexible_server_database.pe.name
  description = "The name of the PostgreSQL Database"
}
