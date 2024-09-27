resource "google_sql_database_instance" "postgres_instance" {
  name             = "postgres-instance"
  database_version = "POSTGRES_13"
  region           = var.region

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = true

      authorized_networks {
        name  = "metabase-instance"
        value = google_compute_address.metabase_ip.address
      }
    }
  }
}