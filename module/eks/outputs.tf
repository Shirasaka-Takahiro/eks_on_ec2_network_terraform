output "eks_cluster_id" {
  value = aws_eks_cluster.default.id
}

output "eks_cluster_name" {
  value = aws_eks_cluster.default.name
}