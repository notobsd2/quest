provider "aws" {
    region = "us-east-2"
}
terraform {
  backend "s3" {
      bucket = "bsd-quest-state-bucket"
      key = "terraform.tfstate"
      region = aws.region
    
  }
}