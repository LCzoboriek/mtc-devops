variable "vpc_cidr" {
  type    = string
  default = var.vpc_cidr
}

variable "public_cidrs" {
  type    = list(string)
  default = var.public_cidrs
}

variable "private_cidrs" {
  type    = list(string)
  default = var.private_cidrs
}