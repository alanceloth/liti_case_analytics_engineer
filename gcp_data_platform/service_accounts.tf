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

resource "google_service_account" "mongodb_sa" {
  account_id   = "mongodb-sa"
  display_name = "MongoDB Service Account"
}

resource "google_service_account" "cloud_function_sa" {
  account_id   = "cloudfunction-sa"
  display_name = "Conta de Serviço para Cloud Functions"
}