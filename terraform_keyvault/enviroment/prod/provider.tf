terraform {
  backend "azurerm" {
    resource_group_name  = "rg_kumar"
    storage_account_name = "yogistorage"
    container_name       = "yogi"
    key                  = "yogi.tfstate"

  }
       
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=5.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}