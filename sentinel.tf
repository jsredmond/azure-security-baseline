resource "azurerm_resource_group" "rg_sentinel" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_management_lock" "rg_lock_sentinel" {
  name       = "resourge-group-sentinel-lock"
  scope      = azurerm_resource_group.rg_sentinel.id
  lock_level = "ReadOnly"
  notes      = "This Resource Group is Read-Only"
}

resource "azurerm_log_analytics_workspace" "law_sentinel" {
  name                                    = var.law_name
  location                                = azurerm_resource_group.rg_sentinel.location
  resource_group_name                     = azurerm_resource_group.rg_sentinel.name
  sku                                     = "PerGB2018"
  retention_in_days                       = 30
  daily_quota_gb                          = 1
  internet_ingestion_enabled              = false
  internet_query_enabled                  = false
  immediate_data_purge_on_30_days_enabled = true
}

resource "azurerm_sentinel_log_analytics_workspace_onboarding" "sentinel" {
  workspace_id = azurerm_log_analytics_workspace.law_sentinel.id
}

resource "azurerm_sentinel_data_connector_azure_active_directory" "sentinel_dc_aad" {
  name                       = "dc-aad"
  log_analytics_workspace_id = azurerm_sentinel_log_analytics_workspace_onboarding.sentinel.workspace_id
}

resource "azurerm_sentinel_data_connector_office_365" "sentinel_dc_365" {
  name                       = "dc-365"
  log_analytics_workspace_id = azurerm_sentinel_log_analytics_workspace_onboarding.sentinel.workspace_id
}