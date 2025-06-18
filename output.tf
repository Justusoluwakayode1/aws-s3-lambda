output "s3_bucket_name" {
  value = aws_s3_bucket.trigger_bucket.id
}

output "lambda_function_name" {
  value = aws_lambda_function.s3_trigger.function_name
}
