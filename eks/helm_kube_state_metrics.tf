resource "helm_release" "kube_state_metrics" {
  name             = "kube-state-metrics"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-state-metrics"
  namespace        = "observability"
  create_namespace = true

  set {
    name  = "apiService.create"
    value = "true"
  }

  depends_on = [
    aws_eks_cluster.aws_eks,
    aws_eks_node_group.this,
    kubernetes_config_map.aws-auth
  ]
}
