module "vpc" {
  source = "./modules/vpc"

  region          = var.region
  deployment_name = var.deployment_name
}

module "eks" {
  source = "./modules/eks"

  region     = var.region
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
}

module "api-gw" {
  source      = "./modules/api-gateway"
  target_arns = ["arn:aws:elasticloadbalancing:us-east-1:375649924539:loadbalancer/net/ac0075d28aa8e4e6c9db8e13c8b20806/cd09044311170f3f"]
}
