variable "project" {
  type = "string"
}

variable "region" {
  type = "string"
  default = "europe-west1"
}

variable "zone" {
  type = "string"
  default = "europe-west1-b"
}

variable "credentials" {
  type = "string"
}

variable "vpc_name" {
  type = "string"
  default = "kube-platform"
}

variable "platform_subnet_name" {
  type = "string"
  default = "platform-net"
}

variable "subnet_cidr" {
  type = "string"
  default = "10.0.0.0/24"
}

variable "public_key" {
  type = "string"
}

variable num_nodes {
  default = 3
}

variable cluster_name {
  default = "dev"
}
