variable "vpc_cidr" {
  type = string

}

variable "access_ip" {
  type = string
}

variable "main_instance_type" {
    type = string
}

variable "main_vol_size" {
    type = number
}

variable "main_instance_count" {
    type = number
    default = 1
}