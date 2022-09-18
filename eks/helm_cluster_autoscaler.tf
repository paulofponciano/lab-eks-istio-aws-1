resource "helm_release" "cluster_autoscaler" {

  name             = "aws-cluster-autoscaler"
  chart            = "./helm/cluster-autoscaler"
  namespace        = "kube-system"
  create_namespace = true

  set {
    name  = "release"
    value = timestamp()
  }

  set {
    name  = "replicaCount"
    value = 1
  }

  set {
    name  = "awsRegion"
    value = var.region
  }

  set {
    name  = "rbac.serviceAccount.create"
    value = true
  }

  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.cluster_autoscaler_role.arn
  }

  set {
    name  = "autoscalingGroups[0].name"
    value = aws_eks_node_group.this.resources[0].autoscaling_groups[0].name
  }

  set {
    name  = "autoscalingGroups[0].maxSize"
    value = var.max_size
  }

  set {
    name  = "autoscalingGroups[0].minSize"
    value = var.min_size
  }

  depends_on = [
    aws_eks_cluster.aws_eks,
    aws_eks_node_group.this,
    kubernetes_config_map.aws-auth
  ]
}
