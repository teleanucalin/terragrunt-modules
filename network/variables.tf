variable "env_name" {
   type = string
   description = "The environment name; used when naming provisioned resources."
   validation {
      condition = can(regex("^[a-z0-9]{3,6}$", var.env_name))
      error_message = "Must be a lowercase alphanumeric value with a minimum length of 3 and a maximum length of 6."
   }
}

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
   default = "small"
   validation {
      condition = can(regex("^(small|medium|large)$", var.env_size))
      error_message = "Must be 'small', 'mediium' or 'large'."
   }
}

variable "env_size_count" {
  type    = map
  default = {
    "small"  = 1
    "medium" = 2
    "large"  = 3
  }
}

variable "env_size_count_data" {
  type    = map
  default = {
    "small"  = 2
    "medium" = 2
    "large"  = 3
  }
}

variable "zones" {
  type = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

locals {
  resource_prefix = "${var.env_name}-core-network"
}