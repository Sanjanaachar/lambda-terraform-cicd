# Create ZIP for Lambda function
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "../lambda/lambda_function.py"
  output_path = "../lambda/lambda_function.zip"
}

# Upload Layer ZIP to S3
resource "aws_s3_object" "layer_zip" {
  bucket = aws_s3_bucket.lambda_bucket.bucket
  key    = "layer.zip"
  source = "../layer/layer.zip"
  etag   = filemd5("../layer/layer.zip")
}

# Create Lambda Layer
resource "aws_lambda_layer_version" "requests_layer" {
  layer_name          = var.layer_name
  s3_bucket           = aws_s3_bucket.lambda_bucket.bucket
  s3_key              = aws_s3_object.layer_zip.key
  compatible_runtimes = ["python3.11"]
}

# Create Lambda Function
resource "aws_lambda_function" "sample_lambda" {
  function_name = var.lambda_function_name

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  role    = aws_iam_role.lambda_role.arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.11"

  layers = [
    aws_lambda_layer_version.requests_layer.arn
  ]
}