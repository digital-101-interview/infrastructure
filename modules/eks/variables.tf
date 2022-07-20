variable "cluster_name" {
  type    = string
  default = "aws"
}

variable "cluster_env" {
  type    = string
  default = "sandbox"
}

variable "subnet_ids" {
  type    = list(string)
  default = [""]
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "enable_irsa" {
  type    = bool
  default = true
}

variable "write_kubeconfig" {
  type    = bool
  default = false
}

variable "manage_aws_auth" {
  type    = bool
  default = false
}

variable "public_endpoint" {
  type    = bool
  default = true
}

variable "private_endpoint" {
  type    = bool
  default = false
}

variable "capacity_type" {
  type    = string
  default = "SPOT"
}

variable "node_group_ami_type" {
  type    = string
  default = "AL2_x86_64"
}

variable "node_group_disk_size" {
  type    = string
  default = 50
}

variable "cluster_version" {
  type    = string
  default = "1.21"
}

variable "node_group_spot_name" {
  type    = string
  default = "spot_node_group"
}

variable "node_group_spot_desired_capacity" {
  type    = string
  default = 2
}

variable "node_group_spot_max_capacity" {
  type    = string
  default = 5
}

variable "node_group_spot_min_capacity" {
  type    = string
  default = 2
}

variable "node_group_spot_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "cluster_endpoint_private_access_sg" {
  type        = list(string)
  default     = null
  description = "List of security group IDs which can access the Amazon EKS private API server endpoint. To use this cluster_endpoint_private_access and cluster_create_endpoint_private_access_sg_rule must be set to true."
}

variable "cluster_create_endpoint_private_access_sg_rule" {
  description = "Whether to create security group rules for the access to the Amazon EKS private API server endpoint. When is `true`, `cluster_endpoint_private_access_cidrs` must be setted."
  type        = bool
  default     = false
}

variable "cluster_endpoint_private_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS private API server endpoint. To use this `cluster_endpoint_private_access` and `cluster_create_endpoint_private_access_sg_rule` must be set to `true`."
  type        = list(string)
  default     = null
}

variable "aws_lb_controller_name" {
  description = "The name of chart aws-alb-ingress-controller"
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "aws_lb_controller_namespace" {
  description = "The namespace to install aws-alb-ingress-controller"
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "node_group_on_demand_desired_capacity" {
  type    = string
  default = 1
}

variable "node_group_on_demand_maximum_capacity" {
  type    = string
  default = 5
}

variable "node_group_on_demand_minimum_capacity" {
  type    = string
  default = 1
}

variable "node_group_on_demand_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "on_demand_capacity_type" {
  type    = string
  default = "ON_DEMAND"
}

variable "node_group_on_demand_name" {
  type    = string
  default = "on_demand_node_group"
}

# variable "hosted_zone_ids" {
# #   type        = list(string)
# #   description = "The IDs of hosted zones"
# # }
