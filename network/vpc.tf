resource "aws_vpc" "main" {
  cidr_block       = "${var.network_address}.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = local.resource_prefix
    Tier = "root"
  }
}