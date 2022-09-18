
data "aws_iam_policy_document" "eks_nodes_role" {

  version = "2012-10-17"

  statement {

    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"
      ]
    }

  }

}

resource "aws_iam_role" "eks_nodes_role" {
  name               = "role-for-nodes-${var.cluster_name}-eks"
  assume_role_policy = data.aws_iam_policy_document.eks_nodes_role.json

  tags = {
    "Name"    = "role-for-nodes-${var.cluster_name}-eks"
    "Project" = "${var.project}"
    "Env"     = "${var.project_env}"
    Terraform = true
  }
}

resource "aws_iam_role_policy_attachment" "cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "node" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "ecr" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.eks_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.eks_nodes_role.name
}

data "aws_iam_policy_document" "csi_driver" {
  version = "2012-10-17"

  statement {

    effect = "Allow"
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    resources = [
      aws_kms_key.eks.arn
    ]

  }

}

resource "aws_iam_policy" "csi_driver" {
  name        = "policy-for-csi-${var.cluster_name}-eks"
  path        = "/"
  description = var.cluster_name

  policy = data.aws_iam_policy_document.csi_driver.json

  tags = {
    "Name"    = "policy-for-csi-${var.cluster_name}-eks"
    "Project" = "${var.project}"
    "Env"     = "${var.project_env}"
    Terraform = true
  }
}

resource "aws_iam_policy_attachment" "csi_driver" {
  name = "aws_load_balancer_controller_policy"

  roles = [aws_iam_role.eks_nodes_role.name]

  policy_arn = aws_iam_policy.csi_driver.arn
}
