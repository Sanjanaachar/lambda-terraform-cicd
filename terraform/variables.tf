variable "region" {
  default = "us-east-1"
}

variable "bucket_name" {
  default = "sanjana-lambda-layer-bucket"
}

variable "lambda_function_name" {
  default = "sample-lambda"
}

variable "layer_name" {
  default = "sample-layer"
}

variable "codestar_connection_arn" {
  description = "CodeStar Connection ARN"
  type        = string
}