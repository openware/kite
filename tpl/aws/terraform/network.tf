# Create a VPC to launch our instances into
resource "aws_vpc" "default" {
  cidr_block = "${var.aws_vpc_cidr_block}"

  tags {
    Name = "${var.aws_vpc_name}"
    component = "bosh-director"
  }
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
    Name = "bosh-default"
    component = "bosh-director"
  }
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.default.id}"
}

# Create a subnet to launch our instances into
resource "aws_subnet" "default" {
  vpc_id = "${aws_vpc.default.id}"
  availability_zone = "${var.aws_availability_zone}"
  cidr_block = "${var.aws_platform_subnet_cidr_block}"
  map_public_ip_on_launch = false
  tags {
    Name = "${var.aws_platform_subnet_name}"
    component = "bosh-director"
  }
}

# Create an ops_services subnet
resource "aws_subnet" "ops_services" {
  vpc_id = "${aws_vpc.default.id}"
  availability_zone = "${var.aws_availability_zone}"
  cidr_block = "${var.aws_ops_subnet_cidr_block}"
  map_public_ip_on_launch = false
  tags {
    Name = "${var.aws_ops_subnet_name}"
    component = "ops_services"
  }
}

# The default security group
resource "aws_security_group" "boshdefault" {
  name = "boshdefault"
  description = "Default BOSH security group"
  vpc_id = "${aws_vpc.default.id}"
  tags {
    Name = "bosh-default"
    component = "bosh-director"
  }

  # inbound access rules
  ingress {
    from_port = 6868
    to_port = 6868
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 25555
    to_port = 25555
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    self = true
  }

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "udp"
    self = true
  }

  # outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

# Create a Concourse security group
resource "aws_security_group" "concourse-sg" {
  name        = "concourse-sg"
  description = "Concourse security group"
  vpc_id      = "${aws_vpc.default.id}"
  tags {
    Name = "concourse-sg"
    component = "concourse"
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # inbound connections from ELB
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port   = 2222
    to_port     = 2222
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a Vault security group
resource "aws_security_group" "vault-sg" {
  name        = "vault-sg"
  description = "Vault security group"
  vpc_id      = "${aws_vpc.default.id}"
  tags {
    Name = "vault-sg"
    component = "vault"
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # inbound http
  ingress {
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
