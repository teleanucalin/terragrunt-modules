variable "parameters" {
  description = "A list of DB parameter maps to apply"
  type        = list(map(string))
  default     = [
    {
      name  = "binlog_format"
      value = "ROW"
    },
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name           = "character-set-client-handshake"
      value          = "0"
      apply_method   = "pending-reboot"
    },
    {
      name  = "character_set_connection"
      value = "utf8mb4"
    },
    {
      name  = "character_set_database"
      value = "utf8mb4"
    },
    {
      name  = "character_set_filesystem"
      value = "binary"
    },
    {
      name  = "character_set_results"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    },
    {
      name  = "collation_connection"
      value = "utf8mb4_unicode_ci"
    },
    {
      name  = "collation_server"
      value = "utf8mb4_unicode_ci"
    },
    {
      name  = "event_scheduler"
      value = "ON"
    },
    {
      name  = "general_log"
      value = "1"
    },
    {
      name           = "gtid-mode"
      value          = "OFF"
      apply_method   = "pending-reboot"
    },
    {
      name  = "innodb_adaptive_hash_index"
      value = "0"
    },
    {
      name  = "innodb_buffer_pool_size"
      value = "{DBInstanceClassMemory*3/4}"
    },
    {
      name  = "innodb_flush_log_at_trx_commit"
      value = "0"
    },
    {
      name  = "innodb_io_capacity"
      value = "2500"
    },
    {
      name  = "innodb_io_capacity_max"
      value = "3000"
    },
    {
      name           = "innodb_log_buffer_size"
      value          = "8388608"
      apply_method   = "pending-reboot"
    },
    {
      name           = "innodb_log_file_size"
      value          = "268435456"
      apply_method   = "pending-reboot"
    },
    {
      name  = "innodb_lru_scan_depth"
      value = "2000"
    },
    {
      name  = "innodb_monitor_enable"
      value = "module_ddl"
    },
    {
      name  = "innodb_print_all_deadlocks"
      value = "1"
    },
    {
      name           = "innodb_read_io_threads"
      value          = "64"
      apply_method   = "pending-reboot"
    },
    {
      name  = "innodb_thread_concurrency"
      value = "0"
    },
    {
      name           = "innodb_write_io_threads"
      value          = "64"
      apply_method   = "pending-reboot"
    },
    {
      name  = "lock_wait_timeout"
      value = "3600"
    },
    {
      name  = "log_bin_trust_function_creators"
      value = "1"
    },
    {
      name  = "log_output"
      value = "FILE"
    },
    {
      name  = "log_queries_not_using_indexes"
      value = "0"
    },
    {
      name  = "long_query_time"
      value = "3"
    },
    {
      name  = "max_allowed_packet"
      value = "268435456"
    },
    {
      name  = "max_heap_table_size"
      value = "2294967295"
    },
    {
      name  = "net_read_timeout"
      value = "600"
    },
    {
      name  = "net_write_timeout"
      value = "600"
    },
    {
      name  = "optimizer_search_depth"
      value = "0"
    },
    {
      name           = "performance_schema"
      value          = "1"
      apply_method   = "pending-reboot"
    },
    {
      name  = "query_cache_size"
      value = "0"
    },
    {
      name           = "query_cache_type"
      value          = "0"
      apply_method   = "pending-reboot"
    },
    {
      name  = "read_buffer_size"
      value = "162144"
    },
    {
      name  = "read_only"
      value = "{TrueIfReplica}"
    },
    {
      name  = "read_rnd_buffer_size"
      value = "224288"
    },
    {
      name           = "skip_name_resolve"
      value          = "0"
      apply_method   = "pending-reboot"
    },
    {
      name  = "slave_pending_jobs_size_max"
      value = "268435456"
    },
    {
      name  = "slow_query_log"
      value = "1"
    },
    {
      name  = "sync_binlog"
      value = "0"
    },
    {
      name  = "table_open_cache"
      value = "3000"
    },
    {
      name  = "tmp_table_size"
      value = "2294967295"
    }
  ]
}
