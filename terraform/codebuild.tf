resource "aws_codebuild_project" "build_layer" {
  name         = "build-lambda-layer"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = false
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspecs/buildspec-layer.yml"
  }
}

resource "aws_codebuild_project" "upload_s3" {
  name         = "upload-artifacts-to-s3"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = false

    environment_variable {
      name  = "S3_BUCKET"
      value = aws_s3_bucket.pipeline_bucket.bucket
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspecs/buildspec-upload.yml"
  }
}

resource "aws_codebuild_project" "terraform_plan" {
  name         = "terraform-init-plan"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = false
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspecs/buildspec-terraform-plan.yml"
  }
}

resource "aws_codebuild_project" "terraform_apply" {
  name         = "terraform-apply"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = false
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspecs/buildspec-terraform-apply.yml"
  }
}