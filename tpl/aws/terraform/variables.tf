variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

variable "bosh_public_key" {
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

variable "ci_hostname" {
  type = "string"
}

variable "ci_dns_zone_id" {
  type = "string"
}
