terraform {
  required_version = ">= 1.6.0"

  required_providers {
    auth0 = {
      source  = "auth0/auth0"
      version = "~> 1.37.0"
    }
  }

  # POC: local backend, state stored in repo as terraform.tfstate
  # TODO: Replace this with an Azure Blob Storage backend for production:
  # backend "azurerm" {
  #   resource_group_name  = "RG-NAME"
  #   storage_account_name = "STORAGEACCOUNTNAME"
  #   container_name       = "tfstate"
  #   key                  = "auth0-iam/terraform.tfstate"
  # }
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "auth0" {
  domain        = var.auth0_domain
  client_id     = var.auth0_client_id
  client_secret = var.auth0_client_secret
}
