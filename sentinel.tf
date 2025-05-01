resource "azurerm_resource_group" "rg_sentinel" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_log_analytics_workspace" "law_sentinel" {
  name                = var.law_name
  location            = azurerm_resource_group.rg_sentinel.location
  resource_group_name = azurerm_resource_group.rg_sentinel.name
  sku                 = "PerGB2018"
}

resource "azurerm_sentinel_log_analytics_workspace_onboarding" "sentinel" {
  workspace_id = azurerm_log_analytics_workspace.law_sentinel.id
}

# resource "azurerm_sentinel_alert_rule_scheduled" "example" {
#   name                       = "example"
#   log_analytics_workspace_id = azurerm_sentinel_log_analytics_workspace_onboarding.example.workspace_id
#   display_name               = "example"
#   severity                   = "High"
#   query                      = <<QUERY
# AzureActivity |
#   where OperationName == "Create or Update Virtual Machine" or OperationName =="Create Deployment" |
#   where ActivityStatus == "Succeeded" |
#   make-series dcount(ResourceId) default=0 on EventSubmissionTimestamp in range(ago(7d), now(), 1d) by Caller
# QUERY
# }