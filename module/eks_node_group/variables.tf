variable "general_config" {
  type = map(any)
}
variable "node_group_exec_role" {}
variable "private_subnet_ids" {}
variable "node_group_desired_size" {}
variable "node_group_max_size" {}
variable "node_group_min_size" {}
variable "node_group_lauch_template_id" {}
variable "node_group_ami_type" {}
variable "node_group_lauch_template_latest_version" {}
variable "node_group_max_unavailable" {}