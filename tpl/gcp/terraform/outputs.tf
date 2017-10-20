output "bastion_ip" {
  value = "${google_compute_address.bastion.address}"
}

output "ingress_ip" {
  value = "${google_compute_address.ingress.address}"
}
