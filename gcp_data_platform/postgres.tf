resource "google_sql_database_instance" "postgres_instance" {
  name             = "postgres-instance"
  database_version = "POSTGRES_13"
  region           = var.region

  settings {
    tier = "db-f1-micro"
  }
}
