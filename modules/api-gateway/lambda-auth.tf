data "aws_caller_identity" "current" {}
//using archive_file data source to zip the lambda code:
data "archive_file" "lambda_code" {
  type        = "zip"
  source_dir  = "${path.module}/authen"
  output_path = "${path.module}/authen.zip"
}


# resource "aws_s3_bucket" "lambda_bucket" {
#   bucket = var.s3_bucket_name
# }

# //making the s3 bucket private as it houses the lambda code:
# resource "aws_s3_bucket_acl" "lambda_bucket_acl" {
#   bucket = aws_s3_bucket.lambda_bucket.id
#   acl    = "private"
# }

# resource "aws_s3_object" "lambda_code" {
#   bucket = aws_s3_bucket.lambda_bucket.id
#   key    = "function_code.zip"
#   source = data.archive_file.lambda_code.output_path
#   etag   = filemd5(data.archive_file.lambda_code.output_path)
# }

resource "aws_lambda_function" "this" {
  function_name    = var.lambda_function_name
  # s3_bucket        = aws_s3_bucket.lambda_bucket.id
  # s3_key           = aws_s3_object.lambda_code.key
  filename                       = "${path.module}/authen.zip"
  runtime          = "python3.8"
  handler          = "index.lambda_handler"
  source_code_hash = data.archive_file.lambda_code.output_base64sha256
  role             = aws_iam_role.lambda_execution_role.arn
  environment {
    variables = {
      REGION     = var.region
      ACCOUNT_ID = data.aws_caller_identity.current.account_id
      API_ID     = aws_api_gateway_rest_api.this.id
      TOKEN      = "abc1234"
    }
  }
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = 30
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role_${var.lambda_function_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}



resource "aws_iam_role" "invocation_role" {
  name = "api_gateway_auth_invocation"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "invocation_policy" {
  name = "default"
  role = aws_iam_role.invocation_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "lambda:InvokeFunction",
      "Effect": "Allow",
      "Resource": "${aws_lambda_function.this.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda" {
  name = "demo-lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}