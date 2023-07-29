## This file contains the variables' values of the environment (Test)

client_public_ip             = ["78.178.105.167/32"]
environment_name             = "test"
region                       = "us-east-2"
region_abr                   = "e-us-2" #East US 2
public_subnet_first_address  = "10.3.1.0/24"
public_subnet_second_address = "10.3.2.0/24"
public_subnet_third_address  = "10.3.3.0/24"
vpc_address                  = "10.3.0.0/16"
region_availability_zone     = ["us-east-2a", "us-east-2b", "us-east-2c"]

ec2_instance_type      = "t2.micro"
eks_node_instance_type = ["t3.small"]
eks_cluster_version    = "1.27"