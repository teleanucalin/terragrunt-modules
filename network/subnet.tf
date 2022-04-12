################################################################################
# Public
################################################################################

resource "aws_subnet" "public" {
  count      = var.env_size_count[var.env_size]
  depends_on = [aws_vpc.main]

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = var.zones[count.index]

  tags = {
    Name = "${local.resource_prefix}-public-${count.index + 1}"
    Tier = "public"
  }
}

################################################################################
# Web
################################################################################

resource "aws_subnet" "web" {
  count      = var.env_size_count[var.env_size]
  depends_on = [aws_vpc.main]

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 7, count.index + 2)
  availability_zone = var.zones[count.index]

  tags = {
    Name = "${local.resource_prefix}-web-${count.index + 1}"
    Tier = "web"
  }
}

################################################################################
# App
################################################################################

resource "aws_subnet" "app" {
  count      = var.env_size_count[var.env_size]
  depends_on = [aws_vpc.main]

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 7, count.index + 5)
  availability_zone = var.zones[count.index]

  tags = {
    Name = "${local.resource_prefix}-app-${count.index + 1}"
    Tier = "app"
  }
}

################################################################################
# Data
################################################################################

resource "aws_subnet" "data" {
  count      = var.env_size_count_data[var.env_size]
  depends_on = [aws_vpc.main,]

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 7, count.index + 9)
  availability_zone = var.zones[count.index]

  tags = {
    Name = "${local.resource_prefix}-data-${count.index + 1}"
    Tier = "data"
  }
}