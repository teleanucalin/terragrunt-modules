resource "aws_nat_gateway" "public" {
  count      = var.env_size_count[var.env_size]
  depends_on = [
    aws_internet_gateway.main,
    aws_subnet.public,
    aws_eip.public
  ]

  allocation_id = aws_eip.public[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name  = "${local.resource_prefix}-public-${count.index + 1}"
    Tier  = "public"
  }
}
