terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.15.0"
    }
  }
}



## START BUCKET ##
resource "aws_s3_bucket" "quest-bucket" {
  bucket = "bsd-test-quest"
  acl    = "private"
}

resource "aws_cloudwatch_log_group" "quest" {
  name = "quest"

  tags = {
    Environment = "production"
    Application = "quest"
  }
}


