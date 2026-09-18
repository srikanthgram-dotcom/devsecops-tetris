output "cluster_name" {
  value = aws_eks_cluster.tetris.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.tetris.endpoint
}
