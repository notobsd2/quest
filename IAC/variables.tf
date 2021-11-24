variable "aws_account_number" {
  type = string
  
}

variable "default_region" {
  
  type = string
  default = "us-east-2"  
}
locals {

  image_version = "latest"
}