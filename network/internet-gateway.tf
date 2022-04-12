resource "aws_internet_gateway" "main" {
  depends_on = [aws_vpc.main]

  vpc_id = aws_vpc.main.id

  tags = {
    Name = local.resource_prefix
    Tier = "root"
  }
}