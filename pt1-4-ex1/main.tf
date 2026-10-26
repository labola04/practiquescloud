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
# Variables
# ------------------------------------------------------------------------------
variable "aws_region" {
  description = "Regió d'AWS on es despleguen els recursos"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Tipus d'instància EC2 requerit per la pràctica"
  type        = string
  default     = "t3.micro"
}

variable "instance_count" {
  description = "Nombre d'instàncies EC2 a crear"
  type        = number
  default     = 2
}

# ------------------------------------------------------------------------------
# Data Sources
# ------------------------------------------------------------------------------
# Obtenció automàtica de la darrera AMI d'Amazon Linux 2023 (x86_64)
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
# Recursos: Instàncies EC2
# ------------------------------------------------------------------------------
resource "aws_instance" "ec2_instances" {
  count         = var.instance_count
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type
  key_name      = "vockey"

  tags = {
    Name        = "pt1-4-ex1-instance-${count.index + 1}"
    Environment = "Laboratori"
    OS          = "Amazon-Linux-2023"
    ManagedBy   = "Terraform"
    Project     = "Pt1.4-Ex1"
    Alumne      = "Laia Bola Simo"
  }
}

# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------
output "ami_id" {
  description = "AMI utilitzada per a les instàncies (Amazon Linux 2023)"
  value       = data.aws_ami.amazon_linux_2023.id
}

output "instance_ids" {
  description = "IDs de les instàncies EC2 creades"
  value       = aws_instance.ec2_instances[*].id
}

output "instance_public_ips" {
  description = "Adreces IP públiques de les instàncies creades"
  value       = aws_instance.ec2_instances[*].public_ip
}

output "instance_private_ips" {
  description = "Adreces IP privades de les instàncies creades"
  value       = aws_instance.ec2_instances[*].private_ip
}
