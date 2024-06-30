# Define the Terraform provider
terraform {
  required_version = "~> 1.8"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

# Define the Azure provider
provider "azurerm" {
  features {}
  environment     = "public"
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
}