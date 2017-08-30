
variable "project" {
    type = "string"
}

variable "region" {
    type = "string"
    default = "us-east1"
}

variable "zone" {
    type = "string"
    default = "us-east1-d"
}

variable "credentials" {
    type = "string"
}

variable "vpc_name" {
    type = "string"
    default = "platform-tools"
}

variable "subnet_cidr" {
    type = "string"
    default = "10.0.0.0/24"
}

variable "public_key" {
  type = "string"
}
