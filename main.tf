provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_address
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_first_address
  availability_zone = var.region_availability_zone[0]
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_second_address
  availability_zone = var.region_availability_zone[1]
}

resource "aws_subnet" "public_subnet_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_third_address
  availability_zone = var.region_availability_zone[2]
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public_subnet_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_subnet_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_subnet_3" {
  subnet_id      = aws_subnet.public_subnet_3.id
  route_table_id = aws_route_table.public.id
}
resource "aws_security_group" "my_security_group" {
  name        = local.security_group_name.name
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id

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

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  desired_capacity = 2
  max_size         = 2
  min_size         = 2

  launch_configuration = aws_launch_configuration.example.id

  vpc_zone_identifier = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id, aws_subnet.public_subnet_3.id]
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = local.eks_cluster_name.name
  cluster_version = var.eks_cluster_version

  vpc_id                         = aws_vpc.main.id
  subnet_ids                     = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id, aws_subnet.public_subnet_3.id]
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name = local.eks_managed_node_group_first.name

      instance_types = var.eks_node_instance_type

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }

    two = {
      name = local.eks_managed_node_group_second.name

      instance_types = var.eks_node_instance_type

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }
}
