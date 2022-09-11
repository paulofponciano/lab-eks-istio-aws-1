# REGIAO DO PROVISIONAMENTO
variable "aws_region" {
  default = "us-east-2"
}

# PRIMEIRA ZONA DE DISPONIBILIDADE
variable "az1" {
  default = "us-east-2a"
}

# SEGUNDA ZONA DE DISPONIBILIDADE
variable "az2" {
  default = "us-east-2b"
}

# USAR AQUI A IDENTIFICACAO DO AMBIENTE
variable "customer_env" {
  default = "pegasus"
}

# INFORME O NOME QUE IRA UTILIZAR NO CLUSTER EKS # IMPORTANTE PARA RESOURCE K8S SHARING
variable "cluster_eks_name" {
  default = "pegasus"
}

# CIDR VPC
variable "vpc_cidr_block" {
  default = "172.28.0.0/16"
}

# SUBNET PUBLICA AZ1
variable "subnet_public_1_cidr" {
  default = "172.28.0.0/20"
}

# SUBNET PUBLICA AZ2
variable "subnet_public_2_cidr" {
  default = "172.28.16.0/20"
}

# SUBNET PRIVADA AZ1
variable "subnet_private_1_cidr" {
  default = "172.28.32.0/20"
}

# SUBNET PRIVADA AZ2
variable "subnet_private_2_cidr" {
  default = "172.28.48.0/20"
}
