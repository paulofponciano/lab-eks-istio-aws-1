# Project info

cluster_name = "pegasus"
project      = "aws_eks"
project_env  = "dev"
region       = "us-east-2"
k8s_version  = "1.23"

# VPC and Subnets

vpc_id         = "vpc-098fcf96c6bf63984"
vpc_cidr_block = "172.28.0.0/16"

public_access_cidrs = [
  "0.0.0.0/0", # ALB ingress and autoscaler requirement
]

subnets = [ # Private subnets for eks cluster
  "subnet-004dc3048338f46d2",
  "subnet-084712a61e733db7c"
]

public_subnets = [ # Public subnets for nlb
  "subnet-06e93c11da6c036fa",
  "subnet-0580216a454f96636"
]

# Autoscaling configuration

instance_type = "t3.medium"
desired_size  = "2"
min_size      = "2"
max_size      = "3"

# Disk

disk_size = "30"

# Endpoint access

endpoint_private_access = false
endpoint_public_access  = true

# Logging

enabled_cluster_log_types = [
  "api",
  "audit",
  "controllerManager"
]

# Istio

kiali_virtual_service_host         = "kiali.sevira.ninja"
grafana_kiali_virtual_service_host = "grafana.sevira.ninja"
