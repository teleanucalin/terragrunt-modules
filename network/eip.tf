resource "aws_eip" "public" {
  count = var.env_size_count[var.env_size]
  vpc   = true

  tags  = {
    Name  = "${local.resource_prefix}-public-${count.index + 1}"
    Tier  = "public"
  }
}