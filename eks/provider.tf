terraform {
  required_providers {
    aws = {
      source  = "aws"
      version = "~> 4.0"
    }
    helm = {
      source  = "helm"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "kubernetes"
      version = "~> 2.0"
    }
    tls = {
      source  = "tls"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.aws_eks.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.aws_eks.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.default.token
  }
}

provider "kubernetes" {
  host                   = aws_eks_cluster.aws_eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.aws_eks.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.default.token
}
