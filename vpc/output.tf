output "eks-vpc" {
  value       = aws_vpc.eks-vpc.id
  description = "VPC ID"
}

output "subnet-public-1" {
  value       = aws_subnet.subnet-public-1.id
  description = "Public subnet AZ1"
}

output "subnet-public-2" {
  value       = aws_subnet.subnet-public-2.id
  description = "Public subnet AZ2"
}

output "subnet-private-1" {
  value       = aws_subnet.subnet-private-1.id
  description = "Private subnet AZ1"
}

output "subnet-private-2" {
  value       = aws_subnet.subnet-private-2.id
  description = "Private subnet AZ2"
}
