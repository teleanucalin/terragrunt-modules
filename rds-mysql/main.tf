locals {
   core_prefix                   = "${var.env_name}-core-db"
   core_primary_db_name          = "${local.core_prefix}-primary"
   core_primary_readonly_db_name = "${local.core_primary_db_name}-readonly"
   core_service_db_name          = "${local.core_prefix}-service"
   tier                          = "data"
}

data "aws_vpc" "main" {
   id   = var.vpc_id
   tags = {
      Name = "${var.env_name}-core-network"
   }
}

data "aws_subnets" "app" {
   depends_on = [data.aws_vpc.main]

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

   tags = {
      Tier = "app"
   }
}

data "aws_subnet" "app" {
  for_each = toset(data.aws_subnets.app.ids)
  id       = each.value
}

data "aws_subnets" "web" {
   depends_on = [data.aws_vpc.main]

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

   tags = {
      Tier = "web"
   }
}

data "aws_subnet" "web" {
  for_each = toset(data.aws_subnets.web.ids)
  id       = each.value
}

data "aws_subnets" "data" {
   depends_on = [data.aws_vpc.main]

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

   tags = {
      Tier = "data"
   }
}

module "sg_mysql" {
  source                   = "../security-groups/sg_cidr"
  vpc_id                   = data.aws_vpc.main.id
  security_group_id        = "dev01_mysql"
  enable_ingress_with_cidr = true
  ingress_ports            = [3306]
  ingress_cidrs            = distinct(concat([for s in data.aws_subnet.app : s.cidr_block], [for s in data.aws_subnet.web : s.cidr_block]))
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

   parameter {
      name  = "binlog_format"
      value = "ROW"
   }

   parameter {
      name  = "character_set_client"
      value = "utf8mb4"
   }

   parameter {
      name           = "character-set-client-handshake"
      value          = "0"
      apply_method   = "pending-reboot"
   }

   parameter {
      name  = "character_set_connection"
      value = "utf8mb4"
   }

   parameter {
      name  = "character_set_database"
      value = "utf8mb4"
   }

   parameter {
      name  = "character_set_filesystem"
      value = "binary"
   }

   parameter {
      name  = "character_set_results"
      value = "utf8mb4"
   }

   parameter {
      name  = "character_set_server"
      value = "utf8mb4"
   }

   parameter {
      name  = "collation_connection"
      value = "utf8mb4_unicode_ci"
   }

   parameter {
      name  = "collation_server"
      value = "utf8mb4_unicode_ci"
   }

   parameter {
      name  = "event_scheduler"
      value = "ON"
   }

   parameter {
      name  = "general_log"
      value = "1"
   }

   parameter {
      name           = "gtid-mode"
      value          = "OFF"
      apply_method   = "pending-reboot"
   }

   parameter {
      name  = "innodb_adaptive_hash_index"
      value = "0"
   }

   parameter {
      name  = "innodb_buffer_pool_size"
      value = "{DBInstanceClassMemory*3/4}"
   }

   parameter {
      name  = "innodb_flush_log_at_trx_commit"
      value = "0"
   }

   parameter {
      name  = "innodb_io_capacity"
      value = "2500"
   }

   parameter {
      name  = "innodb_io_capacity_max"
      value = "3000"
   }

   parameter {
      name           = "innodb_log_buffer_size"
      value          = "8388608"
      apply_method   = "pending-reboot"
   }

   parameter {
      name           = "innodb_log_file_size"
      value          = "268435456"
      apply_method   = "pending-reboot"
   }

   parameter {
      name  = "innodb_lru_scan_depth"
      value = "2000"
   }

   parameter {
      name  = "innodb_monitor_enable"
      value = "module_ddl"
   }

   parameter {
      name  = "innodb_print_all_deadlocks"
      value = "1"
   }

   parameter {
      name           = "innodb_read_io_threads"
      value          = "64"
      apply_method   = "pending-reboot"
   }

   parameter {
      name  = "innodb_thread_concurrency"
      value = "0"
   }

   parameter {
      name           = "innodb_write_io_threads"
      value          = "64"
      apply_method   = "pending-reboot"
   }

   parameter {
      name  = "lock_wait_timeout"
      value = "3600"
   }

   parameter {
      name  = "log_bin_trust_function_creators"
      value = "1"
   }

   parameter {
      name  = "log_output"
      value = "FILE"
   }

   parameter {
      name  = "log_queries_not_using_indexes"
      value = "0"
   }

   parameter {
      name  = "long_query_time"
      value = "3"
   }

   parameter {
      name  = "max_allowed_packet"
      value = "268435456"
   }

   parameter {
      name  = "max_heap_table_size"
      value = "2294967295"
   }

   parameter {
      name  = "net_read_timeout"
      value = "600"
   }

   parameter {
      name  = "net_write_timeout"
      value = "600"
   }

   parameter {
      name  = "optimizer_search_depth"
      value = "0"
   }

   parameter {
      name           = "performance_schema"
      value          = "1"
      apply_method   = "pending-reboot"
   }

   parameter {
      name  = "query_cache_size"
      value = "0"
   }

   parameter {
      name           = "query_cache_type"
      value          = "0"
      apply_method   = "pending-reboot"
   }

   parameter {
      name  = "read_buffer_size"
      value = "162144"
   }

   parameter {
      name  = "read_only"
      value = "{TrueIfReplica}"
   }

   parameter {
      name  = "read_rnd_buffer_size"
      value = "224288"
   }

   parameter {
      name           = "skip_name_resolve"
      value          = "0"
      apply_method   = "pending-reboot"
   }

   parameter {
      name  = "slave_pending_jobs_size_max"
      value = "268435456"
   }

   parameter {
      name  = "slow_query_log"
      value = "1"
   }

   parameter {
      name  = "sync_binlog"
      value = "0"
   }

   parameter {
      name  = "table_open_cache"
      value = "3000"
   }

   parameter {
      name  = "tmp_table_size"
      value = "2294967295"
   }

   tags = {
      Name  = local.core_primary_db_name
      Tier  = local.tier
   }
}

resource "aws_db_subnet_group" "core" {
   depends_on = [data.aws_subnets.data]

   name        = local.core_prefix
   description = "DB Subnet Group for ${local.core_prefix}"
   subnet_ids  = toset(data.aws_subnets.data.ids)

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
