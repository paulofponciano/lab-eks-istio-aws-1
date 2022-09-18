resource "aws_eks_node_group" "this" {

  cluster_name    = aws_eks_cluster.aws_eks.name
  node_group_name = "nodegroup-${var.cluster_name}"
  node_role_arn   = aws_iam_role.eks_nodes_role.arn
  subnet_ids      = var.subnets
  instance_types  = [var.instance_type]
  disk_size       = var.disk_size

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  labels = {
    "ingress/ready" = "true"
  }

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}"     = "owned",
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned",
    "k8s.io/cluster-autoscaler/enabled"             = true
    "Name"                                          = "nodegroup-${var.cluster_name}"
    "Project"                                       = "${var.project}"
    "Env"                                           = "${var.project_env}"
    Terraform                                       = true
  }

  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size
    ]
  }

  depends_on = [
    kubernetes_config_map.aws-auth
  ]
}
