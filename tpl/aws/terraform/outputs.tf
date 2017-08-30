output "security_group_id" {
    value = "${aws_security_group.bosh_sg.id}"
}

output "platform_subnet_id" {
    value = "${aws_subnet.platform.id}"
}

output "ops_services_subnet_id" {
    value = "${aws_subnet.ops_services.id}"
}

output "bastion_ip" {
    value = "${aws_instance.bastion.public_ip}"
}
