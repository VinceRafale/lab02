variable "region" {
  default = "eu-west-1"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet1_cidr_block" {
  default = "10.0.1.0/24"
}

variable "subnet2_cidr_block" {
  default = "10.0.2.0/24"
}

variable "subnet1_az" {
  default = "eu-west-1a"
}

variable "subnet2_az" {
  default = "eu-west-1b"
}
