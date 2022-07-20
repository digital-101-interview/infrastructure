################################################################################
# reusable EIP
################################################################################

# resource "aws_eip" "nat" {
#   count = 1
#   vpc = true
#   tags = {
#     Name        = "${local.name}-nat-eip"
#     Owner       = local.owner
#     Environment = local.environment
#   }
# }

# data "aws_eip" "by_tags" {
#   tags = {
#     Name = var.nat_eip_name
#   }
# }




################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.deployment_name

  cidr = var.cidr

  azs = ["${var.region}a", "${var.region}b"]

  public_subnets = var.public_subnets

  private_subnets = var.private_subnets

  enable_ipv6 = var.enable_ipv6

  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  # reuse_nat_ips       = var.reuse_nat_ips         # <= Skip creation of EIPs for the NAT Gateways
  # external_nat_ip_ids = data.aws_eip.by_tags.*.id # <= IPs specified here as input to the module

  private_subnet_tags = {
    Purpose = var.private_subnets_purpose
  }

  intra_subnet_tags = {
    Purpose = var.intra_subnets_purpose
  }
}
