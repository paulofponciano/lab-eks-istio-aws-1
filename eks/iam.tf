# Roles and attach policies for CLUSTER

resource "aws_iam_role" "eks_cluster" {
  name = "role-for-${var.cluster_name}-eks-cluster"

  assume_role_policy = file("policies/assume_role_eks.json")

  tags = {
    "Name"    = "role-for-${var.cluster_name}-eks-cluster"
    "Project" = "${var.project}"
    "Env"     = "${var.project_env}"
    Terraform = true
  }
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_policy" "policy_auto_scaler" {
  name        = "eks-${var.cluster_name}-autoscaler-policy"
  description = "Policy to cluster auto scaler of ${var.cluster_name} eks cluster"

  policy = file("policies/auto_scaler.json")

  tags = {
    "Name"    = "eks-${var.cluster_name}-autoscaler-policy"
    "Project" = "${var.project}"
    "Env"     = "${var.project_env}"
    Terraform = true
  }
}

# Roles and attach policies for NODES

resource "aws_iam_role" "eks_nodes" {
  name               = "role-for-nodegroup-${var.cluster_name}"
  assume_role_policy = file("policies/assume_role_nodes.json")

  tags = {
    "Name"    = "role-for-nodegroup-${var.cluster_name}"
    "Project" = "${var.project}"
    "Env"     = "${var.project_env}"
    Terraform = true
  }
}

resource "aws_iam_role_policy_attachment" "AmazonAutoScaler" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = aws_iam_policy.policy_auto_scaler.arn
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "CloudWatchLogsFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "CloudWatchReadOnlyAccess" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
  role       = aws_iam_role.eks_nodes.name
}

# ALB ingress controller role and policies attach

resource "aws_iam_policy" "alb_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy-${var.cluster_name}"
  description = "AWSLoadBalancerControllerIAMPolicy"
  policy      = file("policies/alb_controller.json")

  tags = {
    "Name"    = "AWSLoadBalancerControllerIAMPolicy-${var.cluster_name}"
    "Project" = "${var.project}"
    "Env"     = "${var.project_env}"
    Terraform = true
  }
}

resource "aws_iam_role" "alb" {
  name               = "aws-load-balancer-controller-${var.cluster_name}"
  assume_role_policy = templatefile("oidc_assume_role_policy.json", { OIDC_ARN = aws_iam_openid_connect_provider.cluster.arn, OIDC_URL = replace(aws_iam_openid_connect_provider.cluster.url, "https://", ""), NAMESPACE = "kube-system", SA_NAME = "aws-load-balancer-controller" })

  tags = {
    "ServiceAccountName"      = "aws-load-balancer-controller"
    "ServiceAccountNameSpace" = "kube-system"
    "Project"                 = "${var.project}"
    "Env"                     = "${var.project_env}"
    Terraform                 = true
  }

  depends_on = [aws_iam_openid_connect_provider.cluster]
}

resource "aws_iam_role_policy_attachment" "alb" {
  role       = aws_iam_role.alb.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  depends_on = [aws_iam_role.alb]
}

resource "aws_iam_role_policy_attachment" "alb_policy" {
  role       = aws_iam_role.alb.name
  policy_arn = aws_iam_policy.alb_policy.arn
  depends_on = [aws_iam_role.alb]
}

# OIDC provider thumbprint for root CA

data "external" "thumbprint" {
  program = ["bash", "${path.module}/oidc-thumbprint.sh"]
  query = {
    region = var.region
  }
}

data "tls_certificate" "aws_eks" {
  url = aws_eks_cluster.aws_eks.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = concat([data.tls_certificate.aws_eks.certificates.0.sha1_fingerprint], [data.external.thumbprint.result.thumbprint])
  url             = aws_eks_cluster.aws_eks.identity.0.oidc.0.issuer
}
