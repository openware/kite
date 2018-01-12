module "k8s-cluster" {
  source           = "../../../modules/k8s-cluster"
  region           = "${var.region}"
  zone             = "${var.zone}"
  cluster_name     = "production-${random_id.name.hex}"
  machine_type     = "n1-standard-2"
  num_nodes        = 3
}
