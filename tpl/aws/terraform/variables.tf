variable "access_key" {
  type = "string"
}

variable "secret_key" {
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

variable "bucket_name" {
  type = "string"
}

variable "region" {
  type = "string"
  default =  "eu-central-1"
}

variable "availability_zone" {
  type = "string"
  default =  "eu-central-1a"
}

variable "vpc_cidr_block" {
  type = "string"
}

variable "vpc_name" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

variable "public_subnet_cidr" {
  type = "string"
}

variable "public_subnet_id" {
  type = "string"
}

variable "public_subnet_name" {
  type = "string"
}

variable "private_subnet_cidr" {
  type = "string"
}

variable "private_subnet_name" {
  type = "string"
}

variable "aws_amis" {
  default = {
    us-east-1 = "ami-1d4e7a66"
    eu-central-1 = "ami-958128fa"
    eu-west-1 = "ami-785db401"
  }
}
