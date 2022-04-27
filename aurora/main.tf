locals {
  cluster_name = "${var.env_name}-service-mysql"
  tier         = "data"
}

module "sg_mysql" {
  source                   = "../security-groups/sg_cidr"
  vpc_id                   = var.vpc_id
  security_group_id        = "${var.env_name}-mysql"
  enable_ingress_with_cidr = true
  ingress_ports            = [3306]
  ingress_cidrs            = flatten(concat(var.app_subnet_cidr, var.web_subnet_cidr))
}

resource "aws_db_subnet_group" "core" {
   name        = local.cluster_name
   description = "DB Subnet Group for ${local.core_prefix}"
   subnet_ids  = toset(var.data_subnet_ids)

   tags = {
      Name  = local.core_prefix
      Tier  = local.tier
   }
}

resource "aws_rds_cluster" "cluster" {
  allocated_storage                   = "100"
  availability_zones                  = ["${var.region}a", "${var.region}b", "${var.region}c"]
  backup_retention_period             = "1"
  cluster_identifier                  = local.cluster_name
  db_subnet_group_name                = aws_db_subnet_group.core.name
  engine                              = "aurora-mysql"
  engine_version                      = "5.7.mysql_aurora.2.10.2"
  kms_key_id                          = "arn:aws:kms:us-east-1:118244789825:key/mrk-968066b7a2f14c7f99afb6fade374986"
  master_username                     = var.env_name
  master_password                     = var.password
  port                                = "3306"
  storage_encrypted                   = "true"

  tags = {
      Name  = local.cluster_name
      Tier  = local.tier
   }

  vpc_security_group_ids = [module.sg_aurora.security_group_id]
}


resource "aws_rds_cluster_instance" "this" {
  count                                 = var.aurora_read_replica == "true" ? 2 : 1
  db_subnet_group_name                  = aws_db_subnet_group.core.name
  engine                                = "aurora-mysql"
  engine_version                        = "5.7.mysql_aurora.2.10.2"
  identifier                            = "${local.cluster_name}-${count.index}"
  instance_class                        = var.env_size_instance_class[var.env_size]
  port                                  = "3306"
  storage_encrypted                     = "true"

  tags = {
      Name  = "${local.cluster_name}-${count.index}"
      Tier  = local.tier
   }
}
