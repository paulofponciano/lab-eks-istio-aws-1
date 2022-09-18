data "aws_eks_cluster_auth" "default" {
  name = aws_eks_cluster.aws_eks.id
}

data "aws_caller_identity" "current" {}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.aws_eks.id
}
