resource "aws_lb" "eks-nlb" {
  name               = "nlb-${var.cluster_name}-eks-cluster"
  load_balancer_type = "network"
  internal           = false

  subnets = var.public_subnets

  enable_cross_zone_load_balancing = true

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "Name"                                      = "nlb-${var.cluster_name}-eks-cluster"
    "Project"                                   = "${var.project}"
    "Env"                                       = "${var.project_env}"
    Terraform                                   = true
  }
}

resource "aws_lb_target_group" "eks-target-group-http" {
  name     = "tg-http-${var.cluster_name}-eks"
  port     = 30080
  protocol = "TCP"
  vpc_id   = var.vpc_id

  tags = {
    "Name"    = "tg-http-${var.cluster_name}-eks"
    "Project" = "${var.project}"
    "Env"     = "${var.project_env}"
    Terraform = true
  }
}

resource "aws_lb_target_group" "eks-target-group-https" {
  name     = "tg-https-${var.cluster_name}-eks"
  port     = 30443
  protocol = "TCP"
  vpc_id   = var.vpc_id

  tags = {
    "Name"    = "tg-https-${var.cluster_name}-eks"
    "Project" = "${var.project}"
    "Env"     = "${var.project_env}"
    Terraform = true
  }
}

resource "aws_lb_listener" "eks-cluster-listener-https" {
  load_balancer_arn = aws_lb.eks-nlb.arn
  port              = "443"
  protocol          = "TCP"
  # protocol          = "TLS"
  # certificate_arn   = "arn:aws:iam::"
  # alpn_policy       = "HTTP2Preferred"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks-target-group-https.arn
  }
}

resource "aws_lb_listener" "eks-cluster-listener-http" {
  load_balancer_arn = aws_lb.eks-nlb.arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks-target-group-http.arn
  }
}
