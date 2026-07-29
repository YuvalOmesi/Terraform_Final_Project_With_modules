variable "vpc_cidr" {
    type =  string
}

variable "public_subnet_ciders" {
    type = list(string)
}

variable "db_subnet_ciders" {
    type = list(string)
}

variable "private_subnet_ciders" {
    type = list(string)
}

variable "env" {
    type = string
}