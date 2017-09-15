output "security_group_id" {
    value = "${aws_security_group.bosh_sg.id}"
}

output "platform_subnet_id" {
    value = "${aws_subnet.platform_net.id}"
}

output "bastion_ip" {
    value = "${aws_instance.bastion.public_ip}"
}

output "gateway_ip" {
    value = "${aws_nat_gateway.nat_gateway.private_ip}"
}
