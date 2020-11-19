output "windows_node_username" {
  value = random_password.win_username.result
}

output "windows_node_password" {
  value = random_password.win_password.result
}

output "kubernetes_cluster_fqdn" {
    value = azurerm_kubernetes_cluster.this.kube_config.0.host
}

output "node_resource_group_name" {
  value = data.azurerm_kubernetes_cluster.current.node_resource_group
}

output "kubernetes_client_certificate" {
  value = data.azurerm_kubernetes_cluster.current.kube_admin_config[0].client_certificate
}

output "kubernetes_client_key" {
  value = data.azurerm_kubernetes_cluster.current.kube_admin_config[0].client_key
}

output "kubernetes_cluster_ca_certificate" {
  value = data.azurerm_kubernetes_cluster.current.kube_admin_config[0].cluster_ca_certificate
}

output "kubernetes_cluster_tenant_id" {
  value = data.azurerm_kubernetes_cluster.current.identity[0].tenant_id
}

output "kubernetes_kubelet_identity_object_id" {
  value = data.azurerm_kubernetes_cluster.current.kubelet_identity[0].object_id
}

