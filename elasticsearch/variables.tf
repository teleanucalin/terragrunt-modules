/*
variable "network_address" {
   type = string
   description = "The first 2 octets of an IPv4 address with no trailing dot (ex: 172.16)."
   validation {
      condition = can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", var.network_address))
      error_message = "Must be the first 2 octects in an IPv4 address with no trailing dot (ex: 172.16)."
   }
}

variable "region" {
   type = string
   description = "The AWS region in which to provision resources"
   # default = "us-east-1"
}

variable "env_type" {
   type = string
   description = "The type of environment (ex: 'dev' or 'prod')."
}

variable "env_size" {
   type = string
   description = "The size of the environment used to determine how many subnets to provision"
   validation {
      condition = can(regex("^(small|medium|large)$", var.env_size))
      error_message = "Must be 'small', 'mediium' or 'large'."
   }
}*/

variable "vpc_id" {
   type = string
}
variable "app_subnet_cidr" {
   type = list(string)
}
variable "web_subnet_cidr" {
   type = list(string)
}
variable "data_subnet_cidr" {
   type = list(string)
}

variable "env_name" {
   type = string
   description = "The environment name; used when naming provisioned resources."
   validation {
      condition = can(regex("^[a-z0-9]{3,5}$", var.env_name))
      error_message = "Must be a lowercase alphanumeric value with a minimum length of 3 and a maximum length of 5."
   }
}

variable "es_version" {
  type        = string
  default     = "7.10"
  description = "elasticsearch version"
}

variable "instance_type" {
  type        = string
  description = "elasticsearch instance type, e.g. 'm4.large.elasticsearch'"
  default     = "t3.small.elasticsearch"
}

variable "instance_count" {
  type        = number
  default     = 1
  description = "number of instances"
}

/*variable "tags" {
  type = map(string)
}*/

variable "ebs_volume_size" {
  type        = number
  default     = 10
  description = "EBS size in GB"
}
