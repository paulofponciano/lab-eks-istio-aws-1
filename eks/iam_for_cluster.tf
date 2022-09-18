
data "aws_iam_policy_document" "eks_cluster_role" {

  version = "2012-10-17"

  statement {

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = [
        "eks.amazonaws.com",
        "eks-fargate-pods.amazonaws.com"
      ]
    }

  }

}

resource "aws_iam_role" "eks_cluster_role" {
  name               = "role-for-cluster-${var.cluster_name}-eks"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_role.json

  tags = {
    "Name"    = "role-for-cluster-${var.cluster_name}-eks"
    "Project" = "${var.project}"
    "Env"     = "${var.project_env}"
    Terraform = true
  }
}

resource "aws_iam_role_policy_attachment" "eks-cluster-cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks-cluster-service" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_role.name
}
