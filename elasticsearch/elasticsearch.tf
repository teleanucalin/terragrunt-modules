locals {
   elasticsearch_sg_cidr_blocks  = flatten(concat(module.network.app_subnet_cidr, module.network.web_subnet_cidr, module.network.data_subnet_cidr ))
}

/*module "network" {
   source = "../network"
   
   env_size        = var.env_size
   env_name        = var.env_name
   env_type        = var.env_type
   region          = var.region
   network_address = var.network_address
}*/

resource "aws_elasticsearch_domain" "this" {
  depends_on  = [module.network]
  domain_name           = var.env_name
  elasticsearch_version = var.es_version

  cluster_config {
    instance_type  = var.instance_type
    instance_count = var.instance_count
  }

  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = true
    master_user_options {
      master_user_name     = random_string.this.result
      master_user_password = random_password.this.result
    }
  }

  node_to_node_encryption {
    // Required for advanced_security_options
    enabled = true
  }

  domain_endpoint_options {
    // Required for advanced_security_options
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.ebs_volume_size
  }

  encrypt_at_rest {
    enabled = true
  }

  /*vpc_options {
    security_group_ids = [aws_security_group.elasticsearch.id]
    subnet_ids         = slice(module.vpc_data.subnets_private, 0, min(var.instance_count, length(module.vpc_data.subnets_private) - 1))
    // Pick up to #instance subgroups
  }*/

  // tags = var.tags
}

resource "aws_elasticsearch_domain_policy" "this" {
  domain_name     = aws_elasticsearch_domain.this.domain_name
  access_policies = <<POLICIES
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "${aws_elasticsearch_domain.this.arn}/*"
        }
    ]
}
POLICIES
}

module "aws_security_group_elasticsearch" {
  depends_on  = [module.network]
  source      = "../security-groups/sg_cidr"
  vpc_id      = module.network.vpc_id
  security_group_id        = "${var.env_name}-elasticsearch"
  ingress_ports            = [443]
  ingress_cidrs            = local.elasticsearch_sg_cidr_blocks
}


resource "random_string" "this" {
  length  = 16
  lower   = true
  upper   = false
  number  = false
  special = false
}

resource "random_password" "this" {
  length  = 32
  lower   = true
  upper   = true
  number  = true
  special = true
}