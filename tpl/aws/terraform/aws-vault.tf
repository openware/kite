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
