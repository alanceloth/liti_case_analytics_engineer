resource "google_project_iam_member" "airbyte_permissions" {
  for_each = toset([
    "roles/storage.objectAdmin",
    "roles/bigquery.dataEditor",
    "roles/bigquery.jobUser"
  ])
  project = var.project
  role    = each.key
  member  = "serviceAccount:${google_service_account.airbyte_sa.email}"
}

resource "google_storage_bucket_iam_member" "mongodb_sa_access" {
  bucket = "liti_case_analytics_engineer_filedump"
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.mongodb_sa.email}"
}

resource "google_project_iam_member" "cloud_function_pubsub" {
  project = var.project
  role    = "roles/pubsub.subscriber"
  member  = "serviceAccount:${google_service_account.cloud_function_sa.email}"
}

resource "google_project_iam_member" "cloud_function_storage" {
  project = var.project
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.cloud_function_sa.email}"
}

resource "google_project_iam_member" "cloud_function_secret_access" {
  project = var.project
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.cloud_function_sa.email}"
}

resource "google_secret_manager_secret" "airflow_api_username" {
  secret_id = "airflow-api-username"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "airflow_api_username_version" {
  secret  = google_secret_manager_secret.airflow_api_username.id
  secret_data = var.airflow_api_username
}

resource "google_secret_manager_secret" "airflow_api_password" {
  secret_id = "airflow-api-password"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "airflow_api_password_version" {
  secret  = google_secret_manager_secret.airflow_api_password.id
  secret_data = var.airflow_api_password
}


resource "google_secret_manager_secret" "airflow_api_url" {
  secret_id = "airflow-api-url"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "airflow_api_url_version" {
  secret      = google_secret_manager_secret.airflow_api_url.id
  secret_data = "http://${google_compute_address.airflow_ip.address}/api/v1/dags/sync_dags/dagRuns"
}

resource "google_storage_bucket_iam_member" "airflow_bucket_reader" {
  bucket = google_storage_bucket.airflow_dags.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.airflow_sa.email}" 
}

resource "google_pubsub_topic_iam_member" "allow_gcs_publisher" {
  topic  = google_pubsub_topic.dag_updates.name
  role   = "roles/pubsub.publisher"
  member = "serviceAccount:service-1076278144221@gs-project-accounts.iam.gserviceaccount.com"  # Substitua conforme necessário
}
