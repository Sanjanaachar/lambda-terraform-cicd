resource "aws_codepipeline" "pipeline" {

  name     = "lambda-terraform-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.pipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name     = "GitHubSource"
      category = "Source"
      owner    = "AWS"
      provider = "CodeStarSourceConnection"
      version  = "1"

      output_artifacts = ["SourceOutput"]

      configuration = {
        ConnectionArn        = var.codestar_connection_arn
        FullRepositoryId     = "Sanjanaachar/lambda-terraform-cicd"
        BranchName           = "main"
        OutputArtifactFormat = "CODE_ZIP"
      }

      run_order = 1
    }
  }

  stage {
    name = "BuildLayer"

    action {
      name     = "BuildLayer"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"

      input_artifacts  = ["SourceOutput"]
      output_artifacts = ["LayerOutput"]

      configuration = {
        ProjectName = aws_codebuild_project.build_layer.name
      }

      run_order = 1
    }
  }

  stage {
    name = "UploadToS3"

    action {
      name     = "UploadToS3"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"

      input_artifacts  = ["LayerOutput"]
      output_artifacts = ["UploadOutput"]

      configuration = {
        ProjectName = aws_codebuild_project.upload_s3.name
      }

      run_order = 1
    }
  }

  stage {
    name = "TerraformPlan"

    action {
      name     = "TerraformPlan"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"

      input_artifacts  = ["UploadOutput"]
      output_artifacts = ["PlanOutput"]

      configuration = {
        ProjectName = aws_codebuild_project.terraform_plan.name
      }

      run_order = 1
    }
  }

  stage {
    name = "ApproveApply"

    action {
      name     = "ApproveApply"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"

      run_order = 1
    }
  }

  stage {
    name = "TerraformApply"

    action {
      name     = "TerraformApply"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"

      input_artifacts = ["PlanOutput"]

      configuration = {
        ProjectName = aws_codebuild_project.terraform_apply.name
      }

      run_order = 1
    }
  }

  tags = {
    Name = "Lambda Terraform Pipeline"
  }
}