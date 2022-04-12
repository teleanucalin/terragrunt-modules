# data "aws_acm_certificate" "mavrck_vpn" {
#   domain   = "mavrck-${var.env_type}-vpn"
#   statuses = ["ISSUED"]
# }

# resource "aws_ec2_client_vpn_endpoint" "mavrck_vpn" {
#   depends_on = [data.aws_acm_certificate.mavrck_vpn]

#   description             = "VPN Endpoint for ${local.resource_prefix}"
#   server_certificate_arn  = data.aws_acm_certificate.mavrck_vpn.arn
#   client_cidr_block       = "${var.network_address}.4.0/22"
#   split_tunnel            = true

#   authentication_options {
#     type                       = "certificate-authentication"
#     root_certificate_chain_arn = data.aws_acm_certificate.mavrck_vpn.arn
#    }

#   connection_log_options {
#     # TODO: Re-visit; SOC 2 Type II Compliance requires logging all access events
#     enabled = false
#     #  cloudwatch_log_group  = aws_cloudwatch_log_group.lg.name
#     #  cloudwatch_log_stream = aws_cloudwatch_log_stream.ls.name
#    }

#    tags = {
#     Name  = "${local.resource_prefix}-vpn"
#     Tier  = "root"
#    }
# }

# resource "aws_ec2_client_vpn_authorization_rule" "mavrck_vpn" {
#   depends_on = [
#       aws_ec2_client_vpn_endpoint.mavrck_vpn,
#       aws_vpc.main
#    ]

#    authorize_all_groups    = true
#    client_vpn_endpoint_id  = aws_ec2_client_vpn_endpoint.mavrck_vpn.id
#    description             = "Allow all access"
#    target_network_cidr     = aws_vpc.main.cidr_block
# }

# resource "aws_ec2_client_vpn_network_association" "mavrck_vpn_network" {
#   count      = var.env_size_count[var.env_size]
#   depends_on = [
#     aws_ec2_client_vpn_endpoint.mavrck_vpn,
#     aws_subnet.public
#   ]

#  client_vpn_endpoint_id   = aws_ec2_client_vpn_endpoint.mavrck_vpn.id
#  subnet_id                = aws_subnet.public[count.index].id
# }