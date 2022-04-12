variable "security_group_id" {
  type = string
}

variable "ingress_ports" {
  type    = list
  default = []
}

variable "vpc_id" {
  type = string
}

variable "ingress_cidrs" {
  type = list(string)
  default = []
}

variable "enable_ingress_with_cidr" {
  description = "Use cidr insetead of source security group"
  type = bool
  default = false
}

/*variable "enable_ingress_with_ssg" {
  description = "Use source security group instead of cidr"
  type = bool
  default = false
}*/

variable "protocol" {
  type    = string
  default = "tcp"
}