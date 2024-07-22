terraform {
  required_version = ">= 0.12.0"
}

# Cross account AWS Access
provider "aws" {
  alias  = "root"
  region = var.region
  assume_role_with_web_identity {
    role_arn     = var.role_arn
    session_name = "terraform-xaccount"
  }
}
