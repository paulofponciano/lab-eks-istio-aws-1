resource "aws_eip" "eip-ngw-az1" {
  vpc = true
  tags = {
    Name      = join("-", [var.customer_env, "eip-ngw", var.az1])
    Terraform = true
  }
}

resource "aws_eip" "eip-ngw-az2" {
  vpc = true
  tags = {
    Name      = join("-", [var.customer_env, "eip-ngw", var.az2])
    Terraform = true
  }
}

resource "aws_nat_gateway" "ngw-az1" {
  allocation_id = aws_eip.eip-ngw-az1.id
  subnet_id     = aws_subnet.subnet-public-1.id
  depends_on    = [aws_internet_gateway.eks-igw]
  tags = {
    Name      = join("-", [var.customer_env, "ngw", var.az1])
    Terraform = true
  }
}

resource "aws_nat_gateway" "ngw-az2" {
  allocation_id = aws_eip.eip-ngw-az2.id
  subnet_id     = aws_subnet.subnet-public-2.id
  depends_on    = [aws_internet_gateway.eks-igw]
  tags = {
    Name      = join("-", [var.customer_env, "ngw", var.az2])
    Terraform = true
  }
}

resource "aws_route_table" "rt-private-az1" {
  vpc_id = aws_vpc.eks-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw-az1.id
  }

  tags = {
    Name      = join("-", [var.customer_env, "rtb-private", var.az1])
    Terraform = true
  }
}

resource "aws_route_table" "rt-private-az2" {
  vpc_id = aws_vpc.eks-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw-az2.id
  }

  tags = {
    Name      = join("-", [var.customer_env, "rtb-private", var.az2])
    Terraform = true
  }
}

resource "aws_route_table_association" "subnet-private-1" {
  subnet_id      = aws_subnet.subnet-private-1.id
  route_table_id = aws_route_table.rt-private-az1.id
}

resource "aws_route_table_association" "subnet-private-2" {
  subnet_id      = aws_subnet.subnet-private-2.id
  route_table_id = aws_route_table.rt-private-az2.id
}
