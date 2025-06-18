resource "aws_s3_bucket" "trigger_bucket" {
  bucket = var.bucket_name
  force_destroy = true

  tags = {
    Name = var.bucket_name
  }
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.project_name}_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy_attachment" "lambda_basic_attach" {
  name       = "lambda_basic"
  roles      = [aws_iam_role.lambda_exec_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "s3_trigger" {
  function_name = "${var.project_name}_lambda"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_exec_role.arn
  filename      = "${path.module}/lambda/lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda/lambda.zip")
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_trigger.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.trigger_bucket.arn
}

resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = aws_s3_bucket.trigger_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_trigger.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
