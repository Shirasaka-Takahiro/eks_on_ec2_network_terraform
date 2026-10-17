##Provider for ap-northeast-1
provider "aws" {
  profile    = "terraform-user"
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "ap-northeast-1"
}

##Network
module "network" {
  source = "../../module/network"

  general_config          = var.general_config
  availability_zones      = var.availability_zones
  vpc_id                  = module.network.vpc_id
  vpc_cidr                = var.vpc_cidr
  internet_gateway_id     = module.network.internet_gateway_id
  public_subnets          = var.public_subnets
  private_subnets         = var.private_subnets
  public_subnet_ids       = module.network.public_subnet_ids
  private_route_table_ids = module.network.private_route_table_ids
}

##Security Group Internal
module "internal_sg" {
  source = "../../module/securitygroup"

  general_config = var.general_config
  vpc_id         = module.network.vpc_id
  from_port      = 0
  to_port        = 0
  protocol       = "-1"
  cidr_blocks    = ["10.0.0.0/16"]
  sg_role        = "internal"
}

##Secutiry Group Operation
module "operation_sg_1" {
  source = "../../module/securitygroup"

  general_config = var.general_config
  vpc_id         = module.network.vpc_id
  from_port      = 22
  to_port        = 22
  protocol       = "tcp"
  cidr_blocks    = var.operation_sg_1_cidr
  sg_role        = "operation_1"
}

##EC2
module "ec2" {
  source = "../../module/ec2"

  general_config    = var.general_config
  ami               = var.ami
  public_subnets    = var.public_subnets
  public_subnet_ids = module.network.public_subnet_ids
  internal_sg_id    = module.internal_sg.security_group_id
  operation_sg_1_id = module.operation_sg_1.security_group_id
  ec2_role          = var.ec2_role
  key_name          = var.key_name
  public_key_path   = var.public_key_path
  instance_type     = var.instance_type
  volume_type       = var.volume_type
  volume_size       = var.volume_size
}

##EKS
module "eks_cluster" {
  source = "../../module/eks"

  general_config     = var.general_config
  eks_cluster_role   = module.iam_eks_cluster.iam_role_arn
  eks_version        = var.eks_version
  private_subnet_ids = module.network.private_subnet_ids
  internal_sg_id     = module.internal_sg.security_group_id
  eks_cluster_policy = module.iam_eks_cluster.iam_policy_attachment_name
  eks_service_policy = module.iam_eks_service.iam_policy_attachment_name
}

module "eks_addon" {
  source = "../../module/eks_addon"

  general_config = var.general_config
  eks_addon_name = [
    "coredns",
    "kube-proxy",
    "vpc-cni"
  ]
  eks_node_group_name = module.eks_node_group.eks_node_group_name
}

module "eks_node_group" {
  source = "../../module/eks_node_group"

  general_config                           = var.general_config
  private_subnet_ids                       = module.network.private_subnet_ids
  node_group_exec_role                     = module.iam_eks_node_group_exec.iam_role_arn
  node_group_desired_size                  = var.node_group_desired_size
  node_group_max_size                      = var.node_group_max_size
  node_group_min_size                      = var.node_group_min_size
  node_group_lauch_template_id             = module.eks_node_launch_template.node_group_lauch_template_id
  node_group_ami_type                      = var.node_group_ami_type
  node_group_lauch_template_latest_version = module.eks_node_launch_template.node_group_lauch_template_latest_version
  node_group_max_unavailable               = var.node_group_max_unavailable
}

module "eks_node_launch_template" {
  source = "../../module/eks_node_launch_template"

  general_config          = var.general_config
  key_pair_id             = module.ec2.key_pair.id
  node_group_volume_size  = var.node_group_volume_size
  node_group_volume_type  = var.node_group_volume_type
  internal_sg_id          = module.internal_sg.security_group_id
}


##IAM
module "iam_eks_cluster" {
  source = "../../module/iam"

  general_config = var.general_config
  role_name      = var.eks_cluster_role_name
  policy_name    = var.eks_cluster_policy_name
  role_json      = file("../../module/iam_role/eks_assume_role.json")
  policy_json    = file("../../module/iam_role/eks_cluster_policy.json")
}

module "iam_eks_service" {
  source = "../../module/iam"

  general_config = var.general_config
  role_name      = var.eks_service_role_name
  policy_name    = var.eks_service_policy_name
  role_json      = file("../../module/iam_role/eks_assume_role.json")
  policy_json    = file("../../module/iam_role/eks_service_policy.json")
}

module "iam_eks_node_group_exec" {
  source = "../../module/iam"

  general_config = var.general_config
  role_name      = var.eks_node_group_exec_role_name
  policy_name    = var.eks_node_group_exec_policy_name
  role_json      = file("../../module/iam_role/eks_node_group_assume_role.json")
  policy_json    = file("../../module/iam_role/eks_node_group_exec_policy.json")
}