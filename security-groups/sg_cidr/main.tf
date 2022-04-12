resource "aws_security_group" "this" {
  name        = var.security_group_id
  description = "Managed by Terraform"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "ingress_with_cidr" {
  count                    = var.enable_ingress_with_cidr == true ? length(var.ingress_ports) : 0
  type                     = "ingress"
  from_port                = element(var.ingress_ports, count.index)
  to_port                  = element(var.ingress_ports, count.index)
  protocol                 = var.protocol
  cidr_blocks              = var.ingress_cidrs
  description              = ""
  security_group_id        = aws_security_group.this.id
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "All egress traffic"
  security_group_id = aws_security_group.this.id
}