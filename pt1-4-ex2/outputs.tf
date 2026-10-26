output "vpc_id" {
  description = "ID de la VPC personalitzada creada"
  value       = aws_vpc.custom_vpc.id
}

output "vpc_cidr" {
  description = "Bloc CIDR de la VPC"
  value       = aws_vpc.custom_vpc.cidr_block
}

output "subnets_details" {
  description = "Detalls de les subxarxes creades (ID, CIDR i Zona de Disponibilitat)"
  value = {
    for k, s in aws_subnet.subnets : k => {
      id                = s.id
      cidr_block        = s.cidr_block
      availability_zone = s.availability_zone
    }
  }
}

output "instances_details" {
  description = "Llistat de les 6 instàncies EC2 creades amb nom, subxarxa, IPs i ID"
  value = {
    for k, inst in aws_instance.instances : k => {
      id                = inst.id
      name              = inst.tags["Name"]
      subnet_id         = inst.subnet_id
      availability_zone = inst.availability_zone
      private_ip        = inst.private_ip
      public_ip         = inst.public_ip
    }
  }
}
