module "mysql-db" {
  source           = "../../../modules/cloud-sql"
  project          = "${var.project}"
  region           = "${var.region}"
  name             = "master-${random_id.name.hex}"
  tier             = "db-n1-standard-1"
  database_version = "MYSQL_5_7"
}
