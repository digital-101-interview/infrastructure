variable "environment" {
  description = "environment"
  type        = string
  default     = "prod"
}

variable "region" {
  description = "Target AWS region where everything will be placed"
  default     = "us-east-1"
  type        = string
}

variable "deployment_name" {
  description = "Prefix added to all created resources' Name tag."
  default     = "tmp-infra"
  type        = string
}