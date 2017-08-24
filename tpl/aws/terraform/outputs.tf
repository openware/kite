output "security_group_id" {
    value = "${aws_security_group.boshdefault.id}"
}

output "default_subnet_id" {
    value = "${aws_subnet.default.id}"
}

output "ops_services_subnet_id" {
    value = "${aws_subnet.ops_services.id}"
}

output "eip" {
    value = "${aws_eip.boshdirector.public_ip}"
}
