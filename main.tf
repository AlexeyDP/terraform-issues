resource "azurerm_resource_group" "this" {
  location = var.location
  name     = var.resource_group_name
}
resource "tls_private_key" "aks" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "random_password" "win_password" {
  length      = 16
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  special     = false
}

resource "random_password" "win_username" {
  length    = 16
  min_upper = 1
  min_lower = 1
  special   = false
}

data "azurerm_client_config" "current" {

}

resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  node_resource_group = "${var.resource_group_name}aks"
  dns_prefix          = var.cluster_name
  kubernetes_version  = var.cluster_version

  default_node_pool {
    name                 = "default"
    type                 = "VirtualMachineScaleSets"
    node_count           = var.linux_node_count
    max_pods             = var.max_pods
    orchestrator_version = var.cluster_version
    vm_size              = var.cluster_linux_vm_size
  }

  network_profile {
    network_plugin = "azure"
  }

  linux_profile {
    admin_username = "azureuser"
    ssh_key {
      key_data = tls_private_key.aks.public_key_openssh
    }
  }

  windows_profile {
    admin_username = random_password.win_username.result
    admin_password = random_password.win_password.result
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control {
    azure_active_directory {
      managed                = true
      admin_group_object_ids = [data.azurerm_client_config.current.object_id]
    }
    enabled = true
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "pool" {
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  name                  = "wind"
  vm_size               = var.cluster_windows_vm_size
  node_count            = var.windows_node_count
  os_type               = "Windows"
  priority              = var.windows_node_priority
  max_pods              = var.max_pods
  orchestrator_version  = var.cluster_version
}

data "azurerm_kubernetes_cluster" "current" {
  name                = var.cluster_name
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_kubernetes_cluster.this]
}

data "azurerm_resources" "security_network_resource" {
  resource_group_name = "${var.resource_group_name}aks"
  type                = "Microsoft.Network/networkSecurityGroups"
  depends_on          = [azurerm_kubernetes_cluster_node_pool.pool]
}