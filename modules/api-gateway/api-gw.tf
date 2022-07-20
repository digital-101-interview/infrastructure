resource "aws_api_gateway_vpc_link" "test" {
  name        = var.name
  target_arns = var.target_arns
}

resource "aws_api_gateway_rest_api" "this" {
  name = var.name
}

resource "aws_api_gateway_authorizer" "this" {
  name                   = "this"
  rest_api_id            = aws_api_gateway_rest_api.this.id
  authorizer_uri         = aws_lambda_function.this.invoke_arn
  authorizer_credentials = aws_iam_role.invocation_role.arn
  identity_source        = "method.request.header.authorizationToken"
  depends_on = [
    aws_lambda_function.this
  ]
}

resource "aws_api_gateway_method" "root" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_rest_api.this.root_resource_id
  http_method   = "GET"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.this.id
  request_models = {
    "application/json" = "Error"
  }
}

resource "aws_api_gateway_integration" "root" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_rest_api.this.root_resource_id
  http_method = aws_api_gateway_method.root.http_method

  request_templates = {
    "application/json" = ""
    "application/xml"  = "#set($inputRoot = $input.path('$'))\n{ }"
  }

  type                    = "HTTP_PROXY"
  uri                     = "http://flaskapp-api.noi.nguyen.com"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"
  content_handling        = "CONVERT_TO_TEXT"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.test.id
}


resource "aws_api_gateway_resource" "header" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "header"
}

resource "aws_api_gateway_method" "header" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.header.id
  http_method   = "GET"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.this.id

  request_models = {
    "application/json" = "Error"
  }
}

resource "aws_api_gateway_integration" "header" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.header.id
  http_method = aws_api_gateway_method.header.http_method

  request_templates = {
    "application/json" = ""
    "application/xml"  = "#set($inputRoot = $input.path('$'))\n{ }"
  }

  type                    = "HTTP_PROXY"
  uri                     = "http://flaskapp-api.noi.nguyen.com/header"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"
  content_handling        = "CONVERT_TO_TEXT"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.test.id
}

resource "aws_api_gateway_deployment" "prod" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.this.root_resource_id,
      aws_api_gateway_method.root.id,
      aws_api_gateway_integration.root.id,
      aws_api_gateway_authorizer.this.id,
      aws_api_gateway_resource.header.id,
      aws_api_gateway_integration.header.id
    ]))
  }
}
resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.prod.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = "prod"
}

resource "aws_api_gateway_method_response" "test" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_rest_api.this.root_resource_id
  http_method = aws_api_gateway_method.root.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}

resource "aws_api_gateway_integration_response" "test" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_rest_api.this.root_resource_id
  http_method = aws_api_gateway_integration.root.http_method
  status_code = aws_api_gateway_method_response.test.status_code
  response_templates = {
    "application/json" = jsonencode({
      body = "Hello from the movies API!"
    })
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}
