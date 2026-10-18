variable "general_config" {
  type = map(any)
}
variable "eks_addon_name" {
  type = list(string)
}
variable "eks_cluster_name" {}
variable "eks_node_group_name" {}