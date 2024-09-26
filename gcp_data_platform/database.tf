resource "google_sql_database" "airflow_db" {
  name     = "airflow_db"
  instance = google_sql_database_instance.postgres_instance.name
}

resource "google_sql_database" "metabase_db" {
  name     = "metabase_db"
  instance = google_sql_database_instance.postgres_instance.name
}
