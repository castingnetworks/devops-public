terraform {
  required_version = ">= 0.12.0"
}

# Cross account AWS Access
provider "aws" {
  alias  = "root"
  region = var.region
  assume_role {
    role_arn     = "arn:aws:iam::463546384433:role/terraform-xaccount"
    session_name = "terraform-xaccount"
    external_id  = "terraform"
  }
}