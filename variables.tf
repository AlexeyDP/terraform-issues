variable "location" {
  type    = string
}

variable "resource_group_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type    = string
}

variable "linux_node_count" {
  type    = string
}

variable "windows_node_count" {
  type    = string
}

variable "cluster_linux_vm_size" {
  type    = string
}

variable "cluster_windows_vm_size" {
  type    = string
}

variable "windows_node_priority" {
  type    = string
}

variable "max_pods" {
  type    = string
}