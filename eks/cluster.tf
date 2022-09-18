
resource "aws_eks_cluster" "aws_eks" {

  name                      = var.cluster_name
  version                   = var.k8s_version
  role_arn                  = aws_iam_role.eks_cluster_role.arn
  enabled_cluster_log_types = var.enabled_cluster_log_types

  vpc_config {
    subnet_ids              = var.subnets
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs

    security_group_ids = [
      aws_security_group.cluster_sg.id,
    ]
  }

  encryption_config {
    provider {
      key_arn = aws_kms_key.eks.arn
    }
    resources = ["secrets"]
  }

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}"     = "shared"
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned",
    "k8s.io/cluster-autoscaler/enabled"             = true
    "Name"                                          = "${var.cluster_name}"
    "Project"                                       = "${var.project}"
    "Env"                                           = "${var.project_env}"
    Terraform                                       = true
  }

}
