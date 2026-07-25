output "bucket_name" {
  value = aws_s3_bucket.lambda_bucket.bucket
}

output "lambda_role_name" {
  value = aws_iam_role.lambda_role.name
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}

output "lambda_function_name" {
  value = aws_lambda_function.sample_lambda.function_name
}

output "lambda_layer_arn" {
  value = aws_lambda_layer_version.requests_layer.arn
}

output "codebuild_project_build_layer" {
  value = aws_codebuild_project.build_layer.name
}

output "codebuild_project_upload_s3" {
  value = aws_codebuild_project.upload_s3.name
}

output "codebuild_project_terraform_plan" {
  value = aws_codebuild_project.terraform_plan.name
}

output "codebuild_project_terraform_apply" {
  value = aws_codebuild_project.terraform_apply.name
}

output "codepipeline_name" {
  value = aws_codepipeline.pipeline.name
}