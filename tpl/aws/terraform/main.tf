# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_key_pair" "platform_key" {
  key_name   = "${var.keypair_name}"
  public_key = "${file("${var.public_key}")}"
}

resource "aws_instance" "bastion" {
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "t2.small"
  key_name = "${var.keypair_name}"

  vpc_security_group_ids = ["${aws_security_group.bosh_sg.id}"]
  subnet_id = "${aws_subnet.platform.id}"

  associate_public_ip_address = true

  tags {
    Name = "bastion"
  }

  connection {
    user = "ubuntu"
    private_key = "${file(var.private_key)}"
  }

  provisioner "remote-exec" {
    inline = [
      "curl -fsSL get.docker.com | sh"
    ]
  }
}
