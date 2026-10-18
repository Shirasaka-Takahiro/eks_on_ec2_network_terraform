resource "aws_eks_node_group" "default" {
  cluster_name    = var.eks_cluster_name
  node_group_name = "${var.general_config["project"]}-${var.general_config["env"]}-node-group"
  node_role_arn   = var.node_group_exec_role
  subnet_ids      = var.private_subnet_ids
  ami_type        = var.node_group_ami_type

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  launch_template {
    id      = var.node_group_lauch_template_id
    version = var.node_group_lauch_template_latest_version
  }

  update_config {
    max_unavailable = var.node_group_max_unavailable
  }

  lifecycle {
    #ignore_changes = [scaling_config[0].desired_size]
  }

  depends_on = [var.eks_cluster_name]


}