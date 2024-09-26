resource "google_sql_user" "airflow_user" {
  name     = "airflow_user"
  instance = google_sql_database_instance.postgres_instance.name
  password = "your-secure-password"
}

resource "google_sql_user" "metabase_user" {
  name     = "metabase_user"
  instance = google_sql_database_instance.postgres_instance.name
  password = "your-secure-password"
}
