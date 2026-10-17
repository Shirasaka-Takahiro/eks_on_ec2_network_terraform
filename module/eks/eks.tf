resource "aws_eks_cluster" "default" {
  name = "${var.general_config["project"]}-${var.general_config["env"]}-cluster"

  version  = var.eks_version
  role_arn = var.eks_cluster_role

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    security_group_ids      = [var.internal_sg_id]
    endpoint_private_access = "true"
    endpoint_public_access  = "true"
  }

  depends_on = [
    var.eks_cluster_policy,
    var.eks_service_policy
  ]

  tags = {
    Name = "${var.general_config["project"]}-${var.general_config["env"]}-cluster"
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}