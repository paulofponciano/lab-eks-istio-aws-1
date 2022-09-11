# Project info

cluster_name = "pegasus"
project      = "aws_eks"
project_env  = "dev"
region       = "us-east-2"
k8s_version  = "1.23"

# VPC and Subnets

vpc_id         = "vpc-0347f122407b8ed22"
vpc_cidr_block = "172.28.0.0/16"

public_access_cidrs = [
  "0.0.0.0/0", # ALB ingress and autoscaler requirement
]

subnets = [ # Private subnets for eks cluster
  "subnet-09d11bb5370d78adf",
  "subnet-01e8c82e5430f87e6"
]

public_subnets = [ # Public subnets for nlb
  "subnet-01ec07750798c8dfc",
  "subnet-0a48e2f94cfb9576f"
]

# Autoscaling configuration

instance_type = "t3.medium"
desired_size  = "2"
min_size      = "2"
max_size      = "3"

# Disk

disk_size = "30"

# Endpoint access

endpoint_private_access = true
endpoint_public_access  = true

# Logging

enabled_cluster_log_types = [
  "api",
  "audit",
  "controllerManager"
]

# Istio

kiali_virtual_service_host         = "kiali.dominio.com"
grafana_kiali_virtual_service_host = "grafana.dominio.com"
