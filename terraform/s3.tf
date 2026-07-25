# Bucket for Lambda layer zip
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "Lambda Layer Bucket"
    Environment = "Dev"
  }
}

# Bucket for CodePipeline artifacts
resource "aws_s3_bucket" "pipeline_bucket" {
  bucket = "sanjana-codepipeline-artifacts-2026"

  tags = {
    Name = "CodePipeline Artifact Store"
  }
}