################################################################################
# Public
################################################################################

resource "aws_route_table" "public" {
  depends_on = [aws_vpc.main]

  vpc_id = aws_vpc.main.id

  tags = {
    Name  = "${local.resource_prefix}-public"
    Tier  = "public"
  }
}

resource "aws_route" "public" {
  depends_on = [
    aws_internet_gateway.main,
    aws_route_table.public
  ]

  route_table_id          = aws_route_table.public.id
  gateway_id              = aws_internet_gateway.main.id
  destination_cidr_block  = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  count      = var.env_size_count[var.env_size]
  depends_on = [
    aws_route_table.public,
    aws_subnet.public
  ]

  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id
}

################################################################################
# Web
################################################################################

resource "aws_route_table" "web" {
  count      = var.env_size_count[var.env_size]
  depends_on = [aws_vpc.main]

  vpc_id = aws_vpc.main.id

  tags = {
    Name  = "${local.resource_prefix}-web-${count.index + 1}"
    Tier  = "web"
  }
}

resource "aws_route_table_association" "web" {
  count      = var.env_size_count[var.env_size]
  depends_on = [
    aws_route_table.web,
    aws_subnet.web
  ]

  route_table_id = aws_route_table.web[count.index].id
  subnet_id      = aws_subnet.web[count.index].id
}

resource "aws_route" "web" {
  count      = var.env_size_count[var.env_size]
  depends_on = [
    aws_nat_gateway.public,
    aws_route_table.web
   ]

  route_table_id          = aws_route_table.web[count.index].id
  nat_gateway_id          = aws_nat_gateway.public[count.index].id
  destination_cidr_block  = "0.0.0.0/0"
}

################################################################################
# App
################################################################################

resource "aws_route_table" "app" {
  count      = var.env_size_count[var.env_size]
  depends_on = [aws_vpc.main]

  vpc_id = aws_vpc.main.id

  tags = {
    Name  = "${local.resource_prefix}-app-${count.index + 1}"
    Tier  = "app"
  }
}

resource "aws_route_table_association" "app" {
  count      = var.env_size_count[var.env_size]
  depends_on = [
    aws_route_table.app,
    aws_subnet.app
  ]

  route_table_id = aws_route_table.app[count.index].id
  subnet_id      = aws_subnet.app[count.index].id
}

resource "aws_route" "app" {
  count      = var.env_size_count[var.env_size]
  depends_on = [
    aws_nat_gateway.public,
    aws_route_table.app
  ]

  route_table_id          = aws_route_table.app[count.index].id
  nat_gateway_id          = aws_nat_gateway.public[count.index].id
  destination_cidr_block  = "0.0.0.0/0"
}

################################################################################
# Data
################################################################################

resource "aws_route_table" "data" {
  count      = var.env_size_count_data[var.env_size]
  depends_on = [aws_vpc.main]

  vpc_id = aws_vpc.main.id

  tags = {
    Name  = "${local.resource_prefix}-data-${count.index + 1}"
    Tier  = "data"
  }
}

resource "aws_route_table_association" "data" {
  count      = var.env_size_count_data[var.env_size]
  depends_on = [
    aws_route_table.data,
    aws_subnet.data
  ]

  route_table_id = aws_route_table.data[count.index].id
  subnet_id      = aws_subnet.data[count.index].id
}

resource "aws_route" "data" {
  count      = var.env_size_count_data[var.env_size]
  depends_on = [
    aws_nat_gateway.public,
    aws_route_table.data
  ]

  route_table_id          = aws_route_table.data[count.index].id
  nat_gateway_id          = var.env_size_count[var.env_size] == 1 ? aws_nat_gateway.public[0].id : aws_nat_gateway.public[count.index].id
  destination_cidr_block  = "0.0.0.0/0"
}