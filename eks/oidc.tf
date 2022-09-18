resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = concat([data.tls_certificate.eks.certificates.0.sha1_fingerprint], [data.external.thumbprint.result.thumbprint])
  url             = aws_eks_cluster.aws_eks.identity.0.oidc.0.issuer
}

data "tls_certificate" "eks" {
  url = aws_eks_cluster.aws_eks.identity[0].oidc[0].issuer
}

data "external" "thumbprint" {
  program = ["bash", "${path.module}/oidc-thumbprint.sh"]
  query = {
    region = var.region
  }
}
