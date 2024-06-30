####################
# Common Variables #
####################
company       = "kopicloud"
app_name      = "pgtest"
environment   = "dev"
location      = "North Europe"

tags = {
  "Environment"      = "Development"
  "Application Name" = "PostgreSQL Test"
}

####################################
# Azure Authentication - KopiCloud #
####################################
azure_subscription_id = "complete-this"
azure_client_id       = "complete-this"
azure_client_secret   = "complete-this"
azure_tenant_id       = "complete-this"

#############
## Network ##
#############
vnet_address_space      = "10.88.0.0/16"
pe_subnet_address_space = "10.88.1.0/24"

##############
## Database ##
##############
postgres_user                = "sqladmin"
postgres_password            = "R3dGR33nCurry"
postgres_server_sku          = "B_Standard_B1ms"
postgres_server_version      = "16"
postgres_server_storage_mb   = 32768
postgres_server_storage_tier = "P4"
postgres_admin_access_cidr   = "0.0.0.0/0"

#######
# DNS #
#######
private_dns_resource_group = "kopicloud-core-dev-we-dns-rg"
