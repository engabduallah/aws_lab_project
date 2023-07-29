locals {
  security_group_name = {
    description = "Specifies the security group name"
    name        = "sec-group-${var.environment_name}-${var.region_abr}-001"
  }
  ec2_instance_name = {
    description = "Specifies the ec2 instance name for launch configuration"
    name        = "ec2-launch-${var.environment_name}-${var.region_abr}-001"
  }
  eks_cluster_name = {
    description = "Specifies the eks cluster name"
    name        = "eks-${var.environment_name}-${var.region_abr}-001"
  }
  eks_managed_node_group_first = {
    description = "Specifies names of eks managed node groups"
    name    = "${var.environment_name}-${var.region_abr}"
  }
  eks_managed_node_group_second = {
    description = "Specifies names of eks managed node groups"
    name    = "${var.environment_name}-${var.region_abr}"
  }
}