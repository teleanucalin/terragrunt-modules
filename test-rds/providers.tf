terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.63"
    }
  }
}

provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::${var.env_aws_account_id}:role/MavrckAdministrator"
  }
}