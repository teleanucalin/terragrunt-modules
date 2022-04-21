variable "vpc_id" {
   type = string
}
variable "data_subnet_ids" {
   type = list(string)
}
variable "web_subnet_cidr" {
   type = list(string)
}
variable "app_subnet_cidr" {
   type = list(string)
}

# variable "db_snapshot_identifier" {
#    type = string
# }
variable "env_name" {
   type = string
   description = "The environment name; used when naming provisioned resources."
   validation {
      condition = can(regex("^[a-z0-9]{3,6}$", var.env_name))
      error_message = "Must be a lowercase alphanumeric value with a minimum length of 3 and a maximum length of 6."
   }
}

variable "region" {
   type = string
   description = "The AWS region in which to provision resources"
   # default = "us-east-1"
}

/*variable "snapshot_source_db_identifier" {
   type = string
   description = "The DB identifier of the database instacne from which the snapshot is associated"
}*/

# variable "db_snapshot_arn" {
#    type = string
# }

# variable "snapshot_identifier" {
#    type = string
#    description = "The name of the snapshot to use when creating the new database instance; leave empty for most recent"
#    default = null
# }

variable "password" {
   type = string
   description = "The password for the MySql Root User"
}


################################################################################
# Experimental Features - not yet ready for prime time
################################################################################

variable "env_size" {
   type = string
   description = "The size of the environment used to determine how many subnets to provision"
   default = "small"
   validation {
      condition = can(regex("^(small|medium|large)$", var.env_size))
      error_message = "Must be 'small', 'mediium' or 'large'."
   }
}

variable "env_size_instance_class" {
  type    = map
  default = {
    "small"  = "db.t3.small"
    "medium" = "db.t3.small"
    "large"  = "db.m5.2xlarge"
  }
}

variable "env_size_count_replica" {
  type    = map
  default = {
    "small"  = 0
    "medium" = 1
    "large"  = 1
  }
}
