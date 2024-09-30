terraform {
  required_providers {
    azurerm = ">= 2.0"
  }
  
  required_version = ">= 0.12"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "moviestore" {
  name     = var.name
  location = var.location
}

module "ServicePrincipal" {
  source                 = "./ServicePrincipal"
  service_principal_name = var.service_principal_name

  depends_on = [
    azurerm_resource_group.moviestore
  ]
}

resource "azurerm_role_assignment" "rolespn" {
  scope                = "/subscriptions/db2fab21-b317-49ff-b657-a54dbaac5ba9"
  role_definition_name = "Contributor"
  principal_id         = module.ServicePrincipal.service_principal_object_id

  depends_on = [
    module.ServicePrincipal
  ]
}

module "keyvault" {
  source                      = "./keyvault"
  keyvault_name               = var.keyvault_name
  location                    = var.location
  resource_group_name         = var.name
  service_principal_name      = var.service_principal_name
  service_principal_object_id = module.ServicePrincipal.service_principal_object_id
  service_principal_tenant_id = module.ServicePrincipal.service_principal_tenant_id

  depends_on = [
    module.ServicePrincipal
  ]
}

module "aks" {
  source                 = "./aks-cluster/"
  service_principal_name = var.service_principal_name
  client_id              = module.ServicePrincipal.client_id
  client_secret          = module.ServicePrincipal.client_secret
  location               = var.location
  resource_group_name    = var.name

  depends_on = [
    module.ServicePrincipal
  ]
}

resource "local_file" "kubeconfig" {
  depends_on = [module.aks]
  filename   = "./kubeconfig"
  content    = module.aks.config
}
