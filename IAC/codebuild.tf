# Create Pipeline. 
resource "aws_codebuild_project" "quest-build-pipeline" {
  name          = "quest-build-pipeline"
  description   = "quest_build_pipeline"
  build_timeout = "5"
  service_role  = aws_iam_role.quest-codebuild-role.arn
  artifacts {
    type = "NO_ARTIFACTS"
  }
  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode = true
    environment_variable {
    name = "AWS_ACCOUNT_ID"
    value = var.aws_account_number 
    }
    environment_variable {
      name = "IMAGE_REPO_NAME"
      value = aws_ecr_repository.quest.name
    }
    environment_variable {
      name = "IMAGE_TAG"
      value = local.image_version
    }
    environment_variable {
      name = "AWS_DEFAULT_REGION"
      value = var.default_region
    }

  }
  
  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.quest-bucket.id}/build-log"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/notobsd2/quest"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "master"

  tags = {
    Environment = "Test"
  }
}
## END PIPELINE ##

