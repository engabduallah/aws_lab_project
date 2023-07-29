provider "aws" {
  region = var.region
}
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "education-vpc"

  cidr = var.vpc_address
  azs  = var.region_availability_zone

  private_subnets = [var.private_subnet_first_address,var.private_subnet_second_address, var.private_subnet_third_address]
  public_subnets  = [var.public_subnet_first_address,var.public_subnet_second_address, var.public_subnet_third_address]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

#  public_subnet_tags = {
#    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
#    "kubernetes.io/role/elb"                      = 1
#  }
#
#  private_subnet_tags = {
#    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
#    "kubernetes.io/role/internal-elb"             = 1
#  }
}
resource "aws_security_group" "my_security_group" {
  name        = local.security_group_name.name
  description = "Allow inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.client_public_ip
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.client_public_ip
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.client_public_ip
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
data "aws_ami" "aws_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
resource "aws_launch_configuration" "example" {
  name            = local.ec2_instance_name.name
  image_id        = data.aws_ami.aws_linux2.id
  instance_type   = var.ec2_instance_type
  security_groups = [aws_security_group.my_security_group.id]

  user_data = file("${path.module}/userdata.sh")
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  desired_capacity = 2
  max_size         = 2
  min_size         = 2

  launch_configuration = aws_launch_configuration.example.id

  vpc_zone_identifier = module.vpc.public_subnets

}

#module "eks" {
#  source  = "terraform-aws-modules/eks/aws"
#  version = "19.15.3"
#
#  cluster_name    = local.eks_cluster_name.name
#  cluster_version = var.eks_cluster_version
#
#  vpc_id                         = aws_vpc.main.id
#  subnet_ids                     = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id, aws_subnet.public_subnet_3.id]
#  cluster_endpoint_public_access = true
#
#  eks_managed_node_group_defaults = {
#    ami_type = "AL2_x86_64"
#
#  }
#
#  eks_managed_node_groups = {
#    one = {
#      name = local.eks_managed_node_group_first.name
#
#      instance_types = var.eks_node_instance_type
#
#      min_size     = 1
#      max_size     = 3
#      desired_size = 2
#    }
#
#    two = {
#      name = local.eks_managed_node_group_second.name
#
#      instance_types = var.eks_node_instance_type
#
#      min_size     = 1
#      max_size     = 2
#      desired_size = 1
#    }
#  }
#}
