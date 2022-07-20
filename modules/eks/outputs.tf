output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_id" {
  description = "The name/id of the EKS cluster. Will block on cluster creation until the cluster is really ready."
  value       = module.eks.cluster_id
}

output "cluster_certificate_authority_data" {
  description = "Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster."
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster OIDC Issuer"
  value       = module.eks.cluster_oidc_issuer_url
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  value       = module.eks.oidc_provider_arn
}

output "cluster_primary_security_group_id" {
  description = " The cluster primary security group ID created by the EKS cluster on 1.14 or later. Referred to as 'Cluster security group' in the EKS console"
  value       = module.eks.cluster_primary_security_group_id
}

output "worker_security_group_id" {
  description = "Security group ID attached to the EKS workers"
  value       = module.eks.worker_security_group_id
}

output "worker_iam_role_name" {
  description = "default IAM role name for EKS worker groups"
  value       = module.eks.worker_iam_role_name
}

output "worker_iam_role_arn" {
  description = "default IAM role ARN for EKS worker groups"
  value       = module.eks.worker_iam_role_arn
}
