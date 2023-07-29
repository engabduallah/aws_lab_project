## This file contains the variables' values of the environment (Test)
variable "client_public_ip" {
  description = "Specifies your public IP to allow the access"
  type        = list(string)
}
variable "environment_name" {
  description = "Specifies the environment name"
  type        = string
}
variable "region" {
  description = "Specifies the region for  all the resources"
  type        = string
}
variable "region_abr" {
  description = "Specifies the region abbreviation for all the resources"
  type        = string
}
variable "public_subnet_first_address" {
  description = "Specifies the address prefix of the first public subnet"
  type        = string
}
variable "public_subnet_second_address" {
  description = "Specifies the address prefix of the second public subnet"
  type        = string
}
variable "public_subnet_third_address" {
  description = "Specifies the address prefix of the third public subnet"
  type        = string
}
variable "vpc_address" {
  description = "Specifies the address prefix of the VPC"
  type        = string
}
variable "region_availability_zone" {
  description = "Specifies region availability zones"
  type        = list(string)
}
variable "ec2_instance_type" {
  description = "Specifies region availability zones"
  type        = string
}
variable "eks_node_instance_type" {
  description = "Specifies eks node instance type"
  type        = list(string)
}
variable "eks_cluster_version" {
  description = "Specifies eks cluster version"
  type        = string
}