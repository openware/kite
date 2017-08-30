variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

variable "public_key" {
  type = "string"
}

variable "private_key" {
  type = "string"
}

variable "keypair_name" {
  type = "string"
}

variable "aws_region" {
  type = "string"
  default =  "eu-central-1"
}

variable "aws_availability_zone" {
  type = "string"
  default =  "eu-central-1a"
}

variable "aws_vpc_cidr_block" {
  type = "string"
}

variable "aws_vpc_name" {
  type = "string"
}

variable "aws_platform_subnet_cidr_block" {
  type = "string"
}

variable "aws_platform_subnet_name" {
  type = "string"
}

variable "aws_ops_subnet_cidr_block" {
  type = "string"
}

variable "aws_ops_subnet_name" {
  type = "string"
}

variable "aws_amis" {
  default = {
    us-east-1 = "ami-1d4e7a66"
    eu-central-1 = "ami-958128fa"
  }
}
