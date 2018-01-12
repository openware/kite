provider "google" {
  credentials = "${file("${var.credentials}")}"
  project = "${var.project}"
  region = "${var.region}"
}

resource "random_id" "name" {
  byte_length = 2
}
