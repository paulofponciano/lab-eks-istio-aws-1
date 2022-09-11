data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.aws_eks.id
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.aws_eks.id
}

resource "aws_eks_cluster" "aws_eks" {
  name                      = var.cluster_name
  role_arn                  = aws_iam_role.eks_cluster.arn
  version                   = var.k8s_version
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

  tags = {
    "Name"    = "${var.cluster_name}"
    "Project" = "${var.project}"
    "Env"     = "${var.project_env}"
    Terraform = true
  }
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.aws_eks.name
  ami_type        = "AL2_x86_64"
  node_group_name = "nodegroup-${var.cluster_name}"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.subnets
  instance_types  = [var.instance_type]
  disk_size       = var.disk_size

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size
    ]
  }

  tags = {
    "Name"                                          = "nodegroup-${var.cluster_name}"
    "Project"                                       = "${var.project}"
    "Env"                                           = "${var.project_env}"
    "kubernetes.io/cluster/${var.cluster_name}"     = "owned"
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled"             = true
    Terraform                                       = true


  }

  labels = {
    "ingress/ready" = "true"
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.AmazonAutoScaler,
    aws_iam_role_policy_attachment.CloudWatchAgentServerPolicy,
    aws_iam_role_policy_attachment.CloudWatchLogsFullAccess,
    aws_iam_role_policy_attachment.CloudWatchReadOnlyAccess,
    kubernetes_config_map.aws-auth,
  ]
}

# Update local kubeconfig to new Cluster
# Optional

resource "null_resource" "update-kubeconfig" {
  provisioner "local-exec" {
    command = <<EOF
    aws eks --region ${var.region} update-kubeconfig --name ${var.cluster_name}
EOF
  }
  depends_on = [
    aws_eks_node_group.this
  ]
}
