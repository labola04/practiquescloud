aws_region        = "us-east-1"
availability_zone = "us-east-1a"
vpc_cidr          = "10.0.0.0/16"
instance_type     = "t3.micro"
instances_per_subnet = 2
key_name          = "vockey"

subnets_config = {
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
