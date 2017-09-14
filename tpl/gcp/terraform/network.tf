resource "google_compute_network" "platform" {
  name       = "${var.vpc_name}"
}

# Subnet for the Platform tools
resource "google_compute_subnetwork" "platform_net" {
  name          = "platform-net"
  ip_cidr_range = "${var.subnet_cidr}"
  network       = "${google_compute_network.platform.self_link}"
}

resource "google_compute_route" "platform-gate" {
  name                   = "platform-gate"
  dest_range             = "0.0.0.0/0"
  network                = "${google_compute_network.platform.name}"
  next_hop_instance      = "${google_compute_instance.bastion.name}"
  next_hop_instance_zone = "${var.zone}"
  priority               = 800
  tags                   = ["no-ip"]
  project                = "${var.project}"
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

# Allow concourse
resource "google_compute_firewall" "allow_concourse" {
  name    = "allow-concourse"
  network = "${google_compute_network.platform.name}"

  allow {
    protocol = "all"
  }

}
