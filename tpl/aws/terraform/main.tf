# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_key_pair" "boshkey" {
  key_name   = "boshkey"
  public_key = "${file("${var.bosh_public_key}")}"
}

resource "aws_instance" "jumpbox" {
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "t2.medium"
  key_name = "boshkey"

  vpc_security_group_ids = ["${aws_security_group.boshdefault.id}"]
  subnet_id = "${aws_subnet.default.id}"

  associate_public_ip_address = true

  tags {
    Name = "jumpbox"
  }

  connection {
    user = "ubuntu"
    private_key = "${file(var.bosh_private_key)}"
  }

  provisioner "remote-exec" {
    inline = [
      "curl -fsSL get.docker.com | sh"
    ]
  }
}
