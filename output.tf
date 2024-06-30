############
## Output ##
############

output "azure_region" {
  value       = azurerm_resource_group.this.location
  description = "The region in which this module should be deployed"
}

