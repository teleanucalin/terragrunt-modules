locals {
   core_prefix                   = "${var.env_name}-core-db"
   core_primary_db_name          = "${local.core_prefix}-primary"
   core_primary_readonly_db_name = "${local.core_primary_db_name}-readonly"
   core_service_db_name          = "${local.core_prefix}-service"
   tier                          = "data"
}

module "sg_mysql" {
  source                   = "../security-groups/sg_cidr"
  vpc_id                   = var.vpc_id
  security_group_id        = "${var.env_name}-mysql"
  enable_ingress_with_cidr = true
  ingress_ports            = [3306]
  ingress_cidrs            = flatten(concat(var.app_subnet_cidr, var.web_subnet_cidr))
}

# data "aws_db_snapshot" "snapshot" {
#    db_snapshot_identifier = "arn:aws:rds:us-east-1:702817390658:snapshot:dev02-core-platform-testing"
#    include_shared = true
#    snapshot_type  = "shared"
# }

resource "aws_db_parameter_group" "core_primary" {
   name        = local.core_primary_db_name
   description = "DB Parameter Group for ${local.core_primary_db_name}"
   family      = "mysql5.7"

   dynamic "parameter" {
      for_each = var.parameters
      content {
         name         = parameter.value.name
         value        = parameter.value.value
         apply_method = lookup(parameter.value, "apply_method", null)
      }
   }

   tags = {
      Name  = local.core_primary_db_name
      Tier  = local.tier
   }
}

resource "aws_db_subnet_group" "core" {
   name        = local.core_prefix
   description = "DB Subnet Group for ${local.core_prefix}"
   subnet_ids  = toset(var.data_subnet_ids)

   tags = {
      Name  = local.core_prefix
      Tier  = local.tier
   }
}

resource "aws_db_instance" "core_primary" {
   depends_on = [
      aws_db_subnet_group.core,
      aws_db_parameter_group.core_primary
   ]

   engine               = "mysql"
   engine_version       = "5.7.34"
   instance_class       = var.env_size_instance_class[var.env_size]

   identifier           = local.core_primary_db_name
   allocated_storage    = 100
   storage_encrypted    = true
   storage_type         = "gp2"

   auto_minor_version_upgrade = false
   backup_retention_period    = var.env_size_count_replica[var.env_size]
   copy_tags_to_snapshot      = true
   delete_automated_backups   = true
   db_subnet_group_name       = aws_db_subnet_group.core.name
   option_group_name          = "default:mysql-5-7"
   parameter_group_name       = aws_db_parameter_group.core_primary.name
   publicly_accessible        = false
   skip_final_snapshot        = true
   vpc_security_group_ids     = [module.sg_mysql.security_group_id]
   kms_key_id                 = "arn:aws:kms:us-east-1:118244789825:key/mrk-968066b7a2f14c7f99afb6fade374986"
   //snapshot_identifier        = data.aws_db_snapshot.snapshot.id

   username             = var.env_name
   password             = var.password

   tags = {
      Name  = local.core_primary_db_name
      Tier  = local.tier
   }

   lifecycle {
     ignore_changes = [
        password,
        snapshot_identifier
      ]
   }
}

resource "aws_db_instance" "core_primary_readonly" {
   count = var.env_size_count_replica[var.env_size]

   depends_on = [
      aws_db_subnet_group.core,
      aws_db_parameter_group.core_primary
   ]

   replicate_source_db    = aws_db_instance.core_primary.id

   instance_class       = "db.t3.small"

   identifier           = local.core_primary_readonly_db_name
   allocated_storage    = 100
   storage_encrypted    = true
   storage_type         = "gp2"

   auto_minor_version_upgrade = false
   backup_retention_period    = 0
   copy_tags_to_snapshot      = true
   delete_automated_backups   = true
   option_group_name          = "default:mysql-5-7"
   parameter_group_name       = aws_db_parameter_group.core_primary.name
   publicly_accessible        = false
   skip_final_snapshot        = true
   vpc_security_group_ids     = [module.sg_mysql.security_group_id]
   kms_key_id                 = "arn:aws:kms:us-east-1:118244789825:key/mrk-968066b7a2f14c7f99afb6fade374986"
   //snapshot_identifier        = data.aws_db_snapshot.snapshot.id

   tags = {
      Name  = local.core_primary_readonly_db_name
      Tier  = local.tier
   }

   lifecycle {
     ignore_changes = [
        password,
        snapshot_identifier
      ]
   }
}
