resource "aws_s3_bucket" "kite_bucket" {
  bucket = "${var.bucket_name}"

  tags {
    Name = "${var.bucket_name}"
    Component = "kite-platform"
  }
}
