#data "aws_iam_policy_document" "assume_role" {
#  statement {
#    effect = "Allow"
#
#    principals {
#      type        = "Service"
#      identifiers = ["lambda.amazonaws.com"]
#    }
#
#    actions = ["sts:AssumeRole"]
#  }
#}
#
#resource "aws_iam_role" "iam_for_lambda" {
#  name               = "iam_for_lambda"
#  assume_role_policy = data.aws_iam_policy_document.assume_role.json
#}
#
#resource "aws_lambda_function" "test_lambda" {
#  filename      = "lambda_function_payload.zip"
#  function_name = "lambda_handler"
#  role          = aws_iam_role.iam_for_lambda.arn
#  handler       = "handler.py"
#  runtime       = "python3.10"
#
#  ephemeral_storage {
#    size = 10240 # Min 512 MB and the Max 10240 MB
#  }
#}
#
#
