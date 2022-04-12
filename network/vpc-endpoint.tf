resource "aws_vpc_endpoint" "s3" {
  depends_on = [
    aws_vpc.main,
    aws_route_table.public,
    aws_route_table.web,
    aws_route_table.app,
    aws_route_table.data
  ]

  vpc_id            = aws_vpc.main.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${var.region}.s3"
  route_table_ids   = flatten([aws_route_table.public.id, aws_route_table.web[*].id, aws_route_table.app[*].id, aws_route_table.data[*].id])

  policy = <<EOT
  {
    "Version":"2012-10-17",
    "Statement": [
        {
          "Effect": "Allow",
          "Principal": "*",
          "Action": ["*"],
          "Resource": ["*"]
        }
    ]
  }
  EOT

  tags = {
    Name  = "${local.resource_prefix}-s3"
    Tier  = "root"
  }
}

resource "aws_vpc_endpoint" "api-gateway" {
  depends_on = [
    aws_vpc.main,
    aws_subnet.public
  ]

  vpc_id             = aws_vpc.main.id
  vpc_endpoint_type  = "Interface"
  service_name       = "com.amazonaws.${var.region}.execute-api"
  subnet_ids         = aws_subnet.public[*].id
  security_group_ids = [aws_vpc.main.default_security_group_id]

  policy = <<EOT
  {
    "Version":"2012-10-17",
    "Statement": [
        {
          "Effect": "Allow",
          "Principal": "*",
          "Action": ["*"],
          "Resource": ["*"]
        }
    ]
  }
  EOT

  tags = {
    Name  = "${local.resource_prefix}-api-gateway"
    Tier  = "root"
  }
}