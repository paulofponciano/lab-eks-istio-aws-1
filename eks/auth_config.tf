resource "kubernetes_config_map" "aws-auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<EOT
- rolearn: ${aws_iam_role.eks_nodes.arn}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
  - system:bootstrappers
  - system:nodes
  - system:node-proxier
EOT
  }

  depends_on = [
    aws_eks_cluster.aws_eks
  ]
}
