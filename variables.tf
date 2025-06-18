variable "region" {
  default     = "us-east-2"
  description = "AWS Region"
}

variable "project_name" {
  default     = "lambda-s3-trigger"
  description = "Project name"
}

variable "bucket_name" {
  default     = "lambda-s3-trigger-demo-bucket-judejust2025"
  description = "S3 bucket name"
}
