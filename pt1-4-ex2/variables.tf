variable "aws_region" {
  description = "Regió principal d'AWS per al desplegament"
  type        = string
  default     = "us-east-1"
}

variable "availability_zone" {
  description = "Zona de Disponibilitat comuna per a les 3 subxarxes sol·licitada a l'enunciat (AZ-1A)"
  type        = string
  default     = "us-east-1a"
}

variable "vpc_cidr" {
  description = "Bloc CIDR per a la VPC principal personalitzada"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnets_config" {
  description = "Configuració de les 3 subxarxes personalitzades sol·licitades"
  type = map(object({
    cidr_block = string
    name       = string
  }))
  default = {
    subnet_a = {
      cidr_block = "10.0.32.0/25"
      name       = "pt1-4-subnet-a"
    }
    subnet_b = {
      cidr_block = "10.0.30.0/23"
      name       = "pt1-4-subnet-b"
    }
    subnet_c = {
      cidr_block = "10.0.33.0/28"
      name       = "pt1-4-subnet-c"
    }
  }
}

variable "instance_type" {
  description = "Tipus d'instància EC2 sol·licitat"
  type        = string
  default     = "t3.micro"
}

variable "instances_per_subnet" {
  description = "Nombre d'instàncies EC2 a desplegar per cada subxarxa"
  type        = number
  default     = 2
}

variable "key_name" {
  description = "Nom del Key Pair d'AWS Academy"
  type        = string
  default     = "vockey"
}
