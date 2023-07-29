## This file contains the variables' values of the environment (Test)

client_public_ip             = ["78.178.105.167/32"]
environment_name             = "test"
region                       = "us-east-1"
region_abr                   = "e-us-1" #East US 1
public_subnet_first_address  = "10.3.1.0/24"
public_subnet_second_address = "10.3.2.0/24"
public_subnet_third_address  = "10.3.3.0/24"

private_subnet_first_address  = "10.3.4.0/24"
private_subnet_second_address = "10.3.5.0/24"
private_subnet_third_address  = "10.3.6.0/24"

vpc_address                  = "10.3.0.0/16"
region_availability_zone     = ["us-east-1a", "us-east-1b", "us-east-1c"]

ec2_instance_type      = "t2.micro"
eks_node_instance_type = ["t3.small"]
eks_cluster_version    = "1.27"