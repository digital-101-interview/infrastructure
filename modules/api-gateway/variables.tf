variable "region" {
  type        = string
  description = "The region in which to create/manage resources"
  default     = "us-east-1"
}

variable "rest_api_name" {
  type        = string
  description = "Name of the API Gateway created"
  default     = "terraform-api-gateway-example"
}

variable "s3_bucket_name" {
  type        = string
  description = "The name of the S3 bucket to store the Lambda function code"
  default     = "terraform-api-gateway-lambda-test" // must be unique - change this to something unique
}

variable "lambda_function_name" {
  type        = string
  description = "The name of the Lambda function"
  default     = "authorization"
}

variable "rest_api_stage_name" {
  type        = string
  description = "The name of the API Gateway stage"
  default     = "prod" //add a stage name as per your requirement
}

variable "name" {
  type        = string
  description = "(optional) describe your variable"
  default     = "appAPI"
}

variable "target_arns" {
  type        = list(any)
  description = "ELB ARN"
}