data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                       = var.keyvault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled   = false
  soft_delete_retention_days = 7
  enable_rbac_authorization  = true
  sku_name                   = "premium"
}

resource "azurerm_key_vault_access_policy" "service_principal_access" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = var.service_principal_tenant_id
  object_id    = var.service_principal_object_id

  secret_permissions = [
    "Get",
  ]
}

resource "azurerm_role_assignment" "subscription_role_assignment" {
  scope                = "/subscriptions/db2fab21-b317-49ff-b657-a54dbaac5ba9"
  role_definition_name = "Contributor"
  principal_id         = var.service_principal_object_id
}
