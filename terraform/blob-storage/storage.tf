


terraform {
  backend "azurerm" {
    resource_group_name  = "backend-moviestore"
    storage_account_name = "backendmoviestoresa"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}