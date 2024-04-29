resource "azurerm_kubernetes_cluster" "default" {
  name = "aks-${local.workload_name}-${random_string.default.result}"
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2as_v5"
  }
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.default.name
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  dns_prefix = local.workload_name

  azure_active_directory_role_based_access_control {
    admin_group_object_ids = [data.azurerm_client_config.default.object_id]
    azure_rbac_enabled     = true
    tenant_id              = data.azurerm_client_config.default.tenant_id
    managed                = true
  }
}
