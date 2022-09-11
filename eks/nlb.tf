resource "aws_lb_target_group" "eks-target-group-http" {
  name              = "tg-http-${var.cluster_name}-eks"
  port              = 32739
  protocol          = "TCP"
  proxy_protocol_v2 = false
  vpc_id            = var.vpc_id

  health_check {
    healthy_threshold   = 3
    interval            = 30
    protocol            = "TCP"
    unhealthy_threshold = 3
  }

  tags = {
    "Name"                                      = "tg-http-${var.cluster_name}-eks"
    "Project"                                   = "${var.project}"
    "Env"                                       = "${var.project_env}"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/service-name"                = "istio-system/istio-ingressgateway"
    Terraform                                   = true
  }
}

resource "aws_lb_target_group" "eks-target-group-https" {
  name              = "tg-https-${var.cluster_name}-eks"
  port              = 30064
  protocol          = "TCP"
  proxy_protocol_v2 = false
  vpc_id            = var.vpc_id

  health_check {
    healthy_threshold   = 3
    interval            = 30
    protocol            = "TCP"
    unhealthy_threshold = 3
  }

  tags = {
    "Name"                                      = "tg-https-${var.cluster_name}-eks"
    "Project"                                   = "${var.project}"
    "Env"                                       = "${var.project_env}"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/service-name"                = "istio-system/istio-ingressgateway"
    Terraform                                   = true
  }
}

resource "aws_lb" "eks-cluster-nlb" {
  name               = "nlb-${var.cluster_name}-eks-cluster"
  load_balancer_type = "network"
  internal           = false
  subnets            = var.public_subnets

  enable_cross_zone_load_balancing = true

  tags = {
    "Name"                                      = "nlb-${var.cluster_name}-eks-cluster"
    "Project"                                   = "${var.project}"
    "Env"                                       = "${var.project_env}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Terraform                                   = true
  }
}

resource "aws_lb_listener" "eks-cluster-listener-https" {
  load_balancer_arn = aws_lb.eks-cluster-nlb.arn

  port     = 443
  protocol = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks-target-group-https.arn
  }

  depends_on = [
    aws_lb_target_group.eks-target-group-https,
    aws_lb.eks-cluster-nlb
  ]
}

resource "aws_lb_listener" "eks-cluster-listener-http" {
  load_balancer_arn = aws_lb.eks-cluster-nlb.arn

  port     = 80
  protocol = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks-target-group-http.arn
  }

  depends_on = [
    aws_lb_target_group.eks-target-group-http,
    aws_lb.eks-cluster-nlb
  ]
}

/*resource "aws_api_gateway_vpc_link" "nlb" {
  name        = var.cluster_name
  description = var.cluster_name
  target_arns = [aws_lb.eks-cluster-nlb.arn]
}*/
