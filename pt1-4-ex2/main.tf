terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ------------------------------------------------------------------------------
# Data Sources
# ------------------------------------------------------------------------------
# Obtenció de la darrera AMI oficial d'Amazon Linux 2023 (x86_64)
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ------------------------------------------------------------------------------
# Recursos de Xarxa: VPC, IGW, Subxarxes i Enrutament
# ------------------------------------------------------------------------------
# VPC Principal Personalitzada (10.0.0.0/16)
resource "aws_vpc" "custom_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "pt1-4-vpc-custom"
    Environment = "Laboratori"
    ManagedBy   = "Terraform"
    Project     = "Pt1.4-Ex2"
    Alumne      = "Laia Bola Simo"
  }
}

# Internet Gateway per connectar la VPC amb Internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name        = "pt1-4-igw"
    Environment = "Laboratori"
    ManagedBy   = "Terraform"
  }
}

# Creació de les 3 subxarxes associades a us-east-1a
resource "aws_subnet" "subnets" {
  for_each = var.subnets_config

  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name        = each.value.name
    CIDR        = each.value.cidr_block
    AZ          = var.availability_zone
    Environment = "Laboratori"
    ManagedBy   = "Terraform"
  }
}

# Taula d'enrutament pública
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "pt1-4-public-rt"
    Environment = "Laboratori"
    ManagedBy   = "Terraform"
  }
}

# Associació de cadascuna de les 3 subxarxes amb la taula d'enrutament
resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group per permetre SSH i ICMP (ping)
resource "aws_security_group" "custom_sg" {
  name        = "pt1-4-sg-allow-access"
  description = "Permet acces SSH i ICMP a les instancies EC2"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    description = "Acces SSH des de qualsevol origen"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP Ping"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Tot el trafic de sortida permes"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "pt1-4-sg-allow-access"
    Environment = "Laboratori"
  }
}

# ------------------------------------------------------------------------------
# Recursos Computacionals: 6 Instàncies EC2 (2 per subxarxa)
# ------------------------------------------------------------------------------
locals {
  # Matriu plana de les 6 instàncies (2 per cada subxarxa)
  ec2_instances = flatten([
    for subnet_key, subnet_val in var.subnets_config : [
      for i in range(1, var.instances_per_subnet + 1) : {
        key        = "${subnet_key}-inst${i}"
        subnet_key = subnet_key
        name       = "pt1-4-${replace(subnet_key, "_", "-")}-ec2-${i}"
      }
    ]
  ])
}

resource "aws_instance" "instances" {
  for_each = { for inst in local.ec2_instances : inst.key => inst }

  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnets[each.value.subnet_key].id
  vpc_security_group_ids = [aws_security_group.custom_sg.id]
  key_name               = var.key_name

  tags = {
    Name        = each.value.name
    SubnetKey   = each.value.subnet_key
    AZ          = var.availability_zone
    OS          = "Amazon-Linux-2023"
    Environment = "Laboratori"
    ManagedBy   = "Terraform"
    Project     = "Pt1.4-Ex2"
    Alumne      = "Laia Bola Simo"
  }
}
