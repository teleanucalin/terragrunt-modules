################################################################################
# Public
################################################################################

resource "aws_network_acl" "public" {
  depends_on = [
     aws_vpc.main,
     aws_subnet.public,
  ]

  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.public[*].id

  egress = [
    {
      rule_no           = "100"
      protocol          = "tcp"
      action            = "allow"
      cidr_block        = "0.0.0.0/0"
      from_port         = 0
      to_port           = 65535
      icmp_code         = null
      icmp_type         = null
      ipv6_cidr_block   = null
    }
  ]

  ingress = [
    {
      rule_no           = 100
      protocol          = "tcp"
      action            = "allow"
      cidr_block        = "0.0.0.0/0"
      from_port         = 80
      to_port           = 80
      icmp_code         = null
      icmp_type         = null
      ipv6_cidr_block   = null
    },
    {
      rule_no           = 101
      protocol          = "tcp"
      action            = "allow"
      cidr_block        = "0.0.0.0/0"
      from_port         = 443
      to_port           = 443
      icmp_code         = null
      icmp_type         = null
      ipv6_cidr_block   = null
    },
    {
      rule_no           = 102
      protocol          = "tcp"
      action            = "allow"
      cidr_block        = "0.0.0.0/0"
      from_port         = 22
      to_port           = 22
      icmp_code         = null
      icmp_type         = null
      ipv6_cidr_block   = null
    },
    {
      rule_no           = 103
      protocol          = "tcp"
      action            = "allow"
      cidr_block        = "0.0.0.0/0"
      from_port         = 1024
      to_port           = 65535
      icmp_code         = null
      icmp_type         = null
      ipv6_cidr_block   = null
    }
  ]

  tags = {
    Name  = "${local.resource_prefix}-public"
    Tier  = "public"
  }
}

################################################################################
# Web
################################################################################

resource "aws_network_acl" "web" {
  depends_on = [
    aws_vpc.main,
    aws_subnet.web,
    aws_subnet.web
  ]

  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.web[*].id

  egress = [
    {
      rule_no           = "100"
      protocol          = "tcp"
      action            = "allow"
      cidr_block        = "0.0.0.0/0"
      from_port         = 0
      to_port           = 65535
      icmp_code         = null
      icmp_type         = null
      ipv6_cidr_block   = null
    }
  ]

  ingress = [
    {
      rule_no           = 100
      protocol          = "tcp"
      action            = "allow"
      cidr_block        = "0.0.0.0/0"
      from_port         = 0
      to_port           = 65535
      icmp_code         = null
      icmp_type         = null
      ipv6_cidr_block   = null
    }
  ]

  tags = {
    Name  = "${local.resource_prefix}-web"
    Tier  = "web"
  }
}

################################################################################
# App
################################################################################

resource "aws_network_acl" "app" {
  depends_on = [
    aws_vpc.main,
    aws_subnet.app,
  ]

  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.app[*].id

  egress = [
    {
      rule_no           = "100"
      protocol          = "tcp"
      action            = "allow"
      cidr_block        = "0.0.0.0/0"
      from_port         = 0
      to_port           = 65535
      icmp_code         = null
      icmp_type         = null
      ipv6_cidr_block   = null
    }
  ]

   ingress = [
    {
      rule_no           = 100
      protocol          = "tcp"
      action            = "allow"
      cidr_block        = "0.0.0.0/0"
      from_port         = 0
      to_port           = 65535
      icmp_code         = null
      icmp_type         = null
      ipv6_cidr_block   = null
    }
  ]

  tags = {
    Name  = "${local.resource_prefix}-app"
    Tier  = "app"
  }
}

################################################################################
# Data
################################################################################

resource "aws_network_acl" "data" {
  depends_on = [
    aws_vpc.main,
    aws_subnet.data,
  ]

  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.data[*].id

  egress = [
    {
      rule_no           = "100"
      protocol          = "tcp"
      action            = "allow"
      cidr_block        = "0.0.0.0/0"
      from_port         = 0
      to_port           = 65535
      icmp_code         = null
      icmp_type         = null
      ipv6_cidr_block   = null
    }
  ]

  ingress = [
    {
      rule_no           = 100
      protocol          = "tcp"
      action            = "allow"
      cidr_block        = "0.0.0.0/0"
      from_port         = 0
      to_port           = 65535
      icmp_code         = null
      icmp_type         = null
      ipv6_cidr_block   = null
    }
  ]

  tags = {
    Name  = "${local.resource_prefix}-data"
    Tier  = "data"
  }
}