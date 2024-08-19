## Lambda

resource "aws_lambda_function" "test_lambda" {
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_handler"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "handler.lambda_handler"
  runtime       = "python3.10"

  ephemeral_storage {
    size = 10240 # Min 512 MB and the Max 10240 MB
  }
}

## Cloudwatch permissions
### Cloudwatch log group creation

resource "aws_cloudwatch_log_group" "function_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.test_lambda.function_name}"
  retention_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}

### Log group policy

resource "aws_iam_policy" "function_logging_policy" {
  name = "function-logging-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect : "Allow",
        Resource : "arn:aws:logs:*:*:*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:GetLogEvents"
        ],
        "Resource" : [
          "arn:aws:logs:sa-east-1:251675404411:log-group:/aws/lambda/hello-world-lambda-dev-hello:log-stream:*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "lambda:InvokeFunction"
        ],
        "Resource" : "arn:aws:lambda:sa-east-1:251675404411:function:lambda_handler"
      }
    ]
  })
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "function_logging_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda.id
  policy_arn = aws_iam_policy.function_logging_policy.arn
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda_cw"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

}




