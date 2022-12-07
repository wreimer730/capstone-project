data "aws_iam_role" "labrole" {
  name = "LabRole"
}

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "src/capstone-lambda.zip"
  function_name = "capstone-lambda"
  role          = data.aws_iam_role.labrole.arn
  handler       = "lambda_function.lambda_handler"
  timeout       = 900 
  

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("src/capstone-lambda.zip")

  runtime = "python3.9"
}

resource "aws_cloudwatch_event_rule" "every_sixty_minutes" {
    name = "every-sixty-minutes"
    description = "Fires every 60 minutes"
    schedule_expression = "rate(60 minutes)"
}

resource "aws_cloudwatch_event_target" "check_foo_every_sixty_minutes" {
    rule = aws_cloudwatch_event_rule.every_sixty_minutes.name
    target_id = "test_lambda"
    arn = aws_lambda_function.test_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_check_foo" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.test_lambda.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.every_sixty_minutes.arn
}