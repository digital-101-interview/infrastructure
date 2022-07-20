module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.24.0"

  cluster_name    = "${var.cluster_env}-${var.cluster_name}"
  cluster_version = var.cluster_version
  subnets         = var.subnet_ids

  tags = {
    Name = "${var.cluster_env}-${var.cluster_name}"
  }

  vpc_id                                         = var.vpc_id
  enable_irsa                                    = var.enable_irsa #<== Set as "true" to create an IAM roles for service accounts to be assumed in the future by another K8S service like certmanager or externalDNS
  manage_aws_auth                                = var.manage_aws_auth
  write_kubeconfig                               = var.write_kubeconfig
  cluster_endpoint_public_access                 = var.public_endpoint
  cluster_endpoint_private_access                = var.private_endpoint
  cluster_endpoint_private_access_sg             = var.cluster_endpoint_private_access_sg
  cluster_endpoint_private_access_cidrs          = var.cluster_endpoint_private_access_cidrs
  cluster_create_endpoint_private_access_sg_rule = var.cluster_create_endpoint_private_access_sg_rule

  node_groups_defaults = {
    ami_type  = var.node_group_ami_type
    disk_size = var.node_group_disk_size
  }

  node_groups = {
    spot = {
      desired_capacity = var.node_group_spot_desired_capacity
      max_capacity     = var.node_group_spot_max_capacity
      min_capacity     = var.node_group_spot_min_capacity

      instance_types = var.node_group_spot_instance_types
      capacity_type  = var.capacity_type
      k8s_labels = {
        NodeGroupName = var.node_group_spot_name
        Environment   = var.cluster_env
      }
      additional_tags = {
        ProjectTag = var.cluster_name
      }
    }
    on_demand = {
      desired_capacity = var.node_group_on_demand_desired_capacity
      max_capacity     = var.node_group_on_demand_maximum_capacity
      min_capacity     = var.node_group_on_demand_minimum_capacity

      instance_types = var.node_group_on_demand_instance_types
      capacity_type  = var.on_demand_capacity_type
      k8s_labels = {
        NodeGroupName = var.node_group_on_demand_name
        Environment   = var.cluster_env
      }
      additional_tags = {
        ProjectTag = var.cluster_name
      }
    }
  }
}
