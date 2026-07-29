##-------------------------------------------##
## General Variables 
##-------------------------------------------##
variable "region" {
  type = string
  default = "il-central-1"
}

variable "env" {
    type = string
    default = "DevOps"
}

##-------------------------------------------##
## Network Variables 
##-------------------------------------------##

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "public_subnet_ciders" {
    type = list(string)
    default = [
        "10.0.1.0/24",
        "10.0.2.0/24"
    ]
}

variable "db_subnet_ciders" {
    type = list(string)
    default = [
        "10.0.21.0/24",
        "10.0.22.0/24"
    ]
}

variable "private_subnet_ciders" {
    type = list(string)
    default = [
        "10.0.11.0/24",
        "10.0.12.0/24"
    ]
}

##-------------------------------------------##
## Server Variables 
##-------------------------------------------##

variable "instance_type" {
  type = string
  default = "t3.micro"
}