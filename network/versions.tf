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

  region     = var.region

  assume_role {

    role_arn = "arn:aws:iam::141406923970:role/MavrckAdministrator"

  }

}
