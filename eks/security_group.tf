resource "aws_security_group" "cluster_sg" {
  name   = "eks-cluster-sg-${var.cluster_name}"
  vpc_id = var.vpc_id

  egress {
    from_port = 0
    to_port   = 0

    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"    = "eks-cluster-sg-${var.cluster_name}"
    "Project" = "${var.project}"
    "Env"     = "${var.project_env}"
    Terraform = true
  }

}

resource "aws_security_group_rule" "nodeport_tcp_http" {
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 32739
  to_port     = 32739
  description = "nodeport_http_istio"
  protocol    = "tcp"

  security_group_id = aws_eks_cluster.aws_eks.vpc_config[0].cluster_security_group_id
  type              = "ingress"
}

resource "aws_security_group_rule" "vpc_full_ingress" {
  cidr_blocks = [var.vpc_cidr_block]
  from_port   = "0"
  to_port     = "0"
  description = "vpc_ingress"
  protocol    = "-1"

  security_group_id = aws_eks_cluster.aws_eks.vpc_config[0].cluster_security_group_id
  type              = "ingress"
}

resource "aws_security_group_rule" "nodeport_tcp_https" {
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = 30064
  to_port     = 30064
  description = "nodeport_https_istio"
  protocol    = "tcp"

  security_group_id = aws_eks_cluster.aws_eks.vpc_config[0].cluster_security_group_id
  type              = "ingress"
}
