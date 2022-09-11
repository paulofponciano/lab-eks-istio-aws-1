# Project info

variable "cluster_name" {
  type        = string
  description = "Set EKS cluster name"
}

variable "project" {
  type        = string
  description = "Set project name"
}

variable "project_env" {
  type        = string
  description = "Set project environment"
}

variable "region" {
  type        = string
  description = "Set AWS region to be used"
}

# VPC and Subnets

variable "vpc_id" {
  type        = string
  description = "Set VPC ID to be used"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR of VPC"
}

variable "subnets" { # Subnets for eks cluster
  description = "Subnets for EKS"
  type        = list(string)
}

variable "public_subnets" { # Subnets for nlb
  description = "Public subnets for nlb"
  type        = list(string)
}

# Endpoint access

variable "endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled. Default to AWS EKS resource and it is false"
  type        = bool
}

variable "endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled. EKS defaults this to a list with 0.0.0.0/0"
  type        = bool
}

variable "public_access_cidrs" {
  type        = list(string)
  description = "Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled. EKS defaults this to a list with 0.0.0.0/0."
}

variable "k8s_version" {
  type        = string
  description = "Set Kubernetes version"
}

# Autoscaling configuration

variable "instance_type" {
  type        = string
  description = "Set instance type for nodes"
}

variable "desired_size" {
  type        = string
  description = "Set initial quantity of nodes running"
}

variable "min_size" {
  type        = string
  description = "Set minimum quantity of nodes running"
}

variable "max_size" {
  type        = string
  description = "Set maximum quantity of nodes running"
}

# Disk

variable "disk_size" {
  type        = string
  description = "Set disk size for nodes"
}

# Logging

variable "enabled_cluster_log_types" {
  description = "A list of the desired control plane logging to enable.  \n For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)"
  type        = list(string)
}

# Istio monitoring

variable "kiali_virtual_service_host" {
  type = string
}

variable "grafana_kiali_virtual_service_host" {
  type = string
}
