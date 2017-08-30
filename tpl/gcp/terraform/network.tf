resource "google_compute_network" "platform" {
  name       = "${var.vpc_name}"
}

# Subnet for the Platform tools
resource "google_compute_subnetwork" "platform_net" {
  name          = "platform-net"
  ip_cidr_range = "${var.subnet_cidr}"
  network       = "${google_compute_network.platform.self_link}"
}

# Allow open access between internal VM
resource "google_compute_firewall" "platform_internal" {
  name    = "platform-internal"
  network = "${google_compute_network.platform.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }
  target_tags = ["platform-internal"]
  source_tags = ["platform-internal"]
}
