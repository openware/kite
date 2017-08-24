variable "aws_access_key_id" {
type = "string"
}
variable "aws_secret_access_key" {
type = "string"
}
variable "aws_region" {
    type = "string"
    default =  "us-east-1"
}
variable "aws_availability_zone" {
    type = "string"
    default =  "us-east-1a"
}
//variable "source_access_block1" {
//type = "string"
//}
variable "ci_hostname" {
type = "string"
}
variable "ci_dns_zone_id" {
type = "string"
}
//variable "ssl_cert_arn" {
//type = "string"
//}
