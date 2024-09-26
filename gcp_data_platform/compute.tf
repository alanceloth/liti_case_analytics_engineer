resource "google_service_account" "airbyte_sa" {
  account_id   = "airbyte-sa"
  display_name = "Airbyte Service Account"
}

resource "google_service_account" "airflow_sa" {
  account_id   = "airflow-sa"
  display_name = "Airflow Service Account"
}

resource "google_service_account" "metabase_sa" {
  account_id   = "metabase-sa"
  display_name = "Metabase Service Account"
}
