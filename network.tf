#########################
## Network - Resources ##
#########################

# Create the Resource Group
resource "azurerm_resource_group" "this" {
  name     = "${lower(replace(var.company," ","-"))}-${var.app_name}-${var.environment}-rg"
  location = var.location

  tags = var.tags
}

# Create the VNET
resource "azurerm_virtual_network" "this" {
  name                = "${lower(replace(var.company," ","-"))}-${var.app_name}-${var.environment}-vnet"
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  tags = var.tags
}

# Create the Subnet for PostgreSQL Private Endpoint
resource "azurerm_subnet" "pe" {
  name                 = "${lower(replace(var.company," ","-"))}-${var.app_name}-${var.environment}-postgres-pe-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.pe_subnet_address_space]

  private_endpoint_network_policies = "Enabled"

  service_endpoints = ["Microsoft.Sql"] 
}

# Create NSG
resource "azurerm_network_security_group" "pe" {
  name                = "${lower(replace(var.company," ","-"))}-${var.app_name}-${var.environment}-postgres-pe-nsg"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  security_rule {
    name                       = "PostgreSQL"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = var.postgres_admin_access_cidr
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "*"
  }
}

# Attach NSG to Subnet
resource "azurerm_subnet_network_security_group_association" "pe" {
  subnet_id                 = azurerm_subnet.pe.id
  network_security_group_id = azurerm_network_security_group.pe.id
}