provider "aws" {
  region = "us-west-2"
}

# -------------------------
# VPC
# -------------------------
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "HybridLabVPC" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "HybridLab-IGW" }
}

# -------------------------
# Subnets
# -------------------------
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2a"
  tags = { Name = "PublicSubnet" }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2a"
  tags = { Name = "PrivateSubnet" }
}

# -------------------------
# NAT Gateway
# -------------------------
resource "aws_eip" "nat" {
  tags = { Name = "HybridLab-NAT-EIP" }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
  tags = { Name = "HybridLab-NATGW" }
}

# -------------------------
# Route Tables
# -------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "PublicRouteTable" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = { Name = "PrivateRouteTable" }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# -------------------------
# Security Groups
# -------------------------
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow SSH from my IP"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["98.36.135.212/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "BastionSG" }
}

resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "Allow SSH from bastion only"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "PrivateEC2SG" }
}

# -------------------------
# EC2 Instances
# -------------------------
resource "aws_instance" "bastion" {
  ami           = "ami-0c2d06d50ce30b442"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  key_name      = "your-key"

  vpc_security_group_ids = [
    aws_security_group.bastion_sg.id
  ]

  tags = { Name = "BastionHost" }
}


resource "aws_instance" "private_ec2" {
  ami           = "ami-0c2d06d50ce30b442"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private.id
  key_name      = "your-key"

  vpc_security_group_ids = [
    aws_security_group.private_sg.id
  ]

  tags = { Name = "PrivateEC2" }
}


