resource "aws_kms_key" "eks" {
  description = var.cluster_name

  tags = {
    "Name"    = "kms-key-for-${var.cluster_name}-eks"
    "Project" = "${var.project}"
    "Env"     = "${var.project_env}"
    Terraform = true
  }
}

resource "aws_kms_alias" "eks" {
  name          = format("alias/%s", var.cluster_name)
  target_key_id = aws_kms_key.eks.key_id
}
