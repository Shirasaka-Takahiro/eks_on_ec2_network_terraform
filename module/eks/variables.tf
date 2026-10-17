variable "general_config" {
  type = map(any)
}
variable "eks_cluster_role" {}
variable "eks_version" {}
variable "private_subnet_ids" {}
variable "internal_sg_id" {}
variable "eks_cluster_policy" {}
variable "eks_service_policy" {}