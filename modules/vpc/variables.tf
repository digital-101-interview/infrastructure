variable "region" {
  description = "Target AWS region where the VPC will be placed"
  type        = string
}

variable "nat_eip_name" {
  description = "Name tag to identify the Elastic IP to be attached to NAT. EIP must already exist in the target region. If it does not, create it manually beforehand."
  type        = string
  default     = "tmp-infra-nat"
}

variable "deployment_name" {
  description = "Prefix added to all created resources' Name tag."
  type        = string
  default     = "test"
}

variable "cidr" {
  description = "VPC CIDR address and mask"
  type        = string
  default     = "10.0.0.0/20"
}

variable "public_subnets" {
  description = "Public subnets' addresses and masks"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnets" {
  description = "Private subnets' addresses and masks (can access internet)"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "intra_subnets" {
  description = "Intra subnets' addresses and masks (no access to internet)"
  type        = list(string)
  default     = ["10.0.6.0/24", "10.0.7.0/24"]
}

variable "database_subnets" {
  description = "Database subnets' addresses and masks"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24"]
}

variable "private_subnets_purpose" {
  description = "Content of Purpose tags"
  type        = string
  default     = "private-LB-for-devs"
}

variable "intra_subnets_purpose" {
  description = "Content of Purpose tags"
  type        = string
  default     = "workers"
}

variable "enable_ipv6" {
  type    = bool
  default = false
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "single_nat_gateway" {
  type    = bool
  default = true
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "reuse_nat_ips" {
  type    = bool
  default = false
}
