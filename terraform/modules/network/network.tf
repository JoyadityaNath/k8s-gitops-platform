# ========================================================
#                   VPC CREATION
# ========================================================

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "k8s-gitops-platform-vpc"
  }
}

# ========================================================
#                   PUBLIC NETWORK
# ========================================================

resource "aws_subnet" "public_subnets" {
  for_each = var.public_subnet_config
  vpc_id=aws_vpc.vpc.id
  availability_zone = each.value.availability_zone
  cidr_block = each.value.cidr_block
  tags = {
    Name = "public-subnet-k8s-gitops-platform-${each.key}"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "public-rt-k8s-gitops-platform"
  }
}


resource "aws_route" "route_pub" {
  route_table_id = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table_association" "this_pub" {
  for_each = aws_subnet.public_subnets
  route_table_id = aws_route_table.public_rt.id
  subnet_id = each.value.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name="igw-k8s-gitops-platform"
  }
}


# ========================================================
#                   PRIVATE NETWORK
# ========================================================

resource "aws_subnet" "private_subnets" {
  for_each = var.private_subnet_config
  vpc_id = aws_vpc.vpc.id
  availability_zone = each.value.availability_zone
  cidr_block = each.value.cidr_block
  tags = {
    Name = "private-subnet-k8s-gitops-platform-${each.key}"
  }
}


resource "aws_nat_gateway" "nat" {
  for_each = aws_subnet.public_subnets
  subnet_id = each.value.id
  allocation_id = aws_eip.eip[each.key].id
  depends_on = [ aws_internet_gateway.igw ]
  tags = {
    Name="nat-gateway-k8s-gitops-platform-${each.key}"
  }
}

resource "aws_eip" "eip" {
  for_each = aws_subnet.public_subnets
  domain = "vpc"
}


resource "aws_route_table" "private_rt" {
  for_each = aws_subnet.private_subnets
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name="private-rt-k8s-gitops-platform-${each.key}"
  }
}

resource "aws_route" "route_pvt" {
  for_each = aws_subnet.private_subnets
  route_table_id = aws_route_table.private_rt[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat[each.key].id
}

resource "aws_route_table_association" "this_pvt" {
  for_each = aws_subnet.private_subnets
  route_table_id = aws_route_table.private_rt[each.key].id
  subnet_id = each.value.id
}



# ========================================================
#                   SECURITY GROUPS
# ========================================================

resource "aws_security_group" "ssm_sg" {
  description = "Sg for SSM egress HTTPS"
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "ec2-sg-k8s-gitops-platform"
  }
}

resource "aws_vpc_security_group_egress_rule" "name" {
  security_group_id = aws_security_group.ssm_sg.id
  from_port = 443
  to_port = 443
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
}