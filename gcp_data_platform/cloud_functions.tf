resource "google_cloudfunctions_function" "trigger_airflow_sync" {
  name        = "trigger-airflow-sync"
  description = "Função para acionar a DAG de sincronização do Airflow quando houver atualizações nas DAGs no GCS."

  runtime = "python39"

  entry_point = "trigger_airflow_sync"

  source_archive_bucket = google_storage_bucket.functions_bucket.name
  source_archive_object = google_storage_bucket_object.function_zip.name

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.dag_updates.id
  }

  environment_variables = {
    GCP_PROJECT            = "${var.project}"
    AIRFLOW_API_URL        = "projects/${var.project}/secrets/airflow-api-url/versions/latest"
    AIRFLOW_API_USERNAME   = "projects/${var.project}/secrets/airflow-api-username/versions/latest"
    AIRFLOW_API_PASSWORD   = "projects/${var.project}/secrets/airflow-api-password/versions/latest"
  }

  service_account_email = google_service_account.cloud_function_sa.email

  depends_on = [
    google_project_service.artifactregistry,
    google_project_service.secretmanager,
    google_project_service.pubsub,
    google_project_service.cloudfunctions,
    google_pubsub_topic_iam_member.allow_gcs_publisher,
    google_secret_manager_secret_version.airflow_api_url_version,
    google_secret_manager_secret_version.airflow_api_username_version,
    google_secret_manager_secret_version.airflow_api_password_version
  ]
}

data "archive_file" "trigger_airflow_sync_zip" {
  type        = "zip"
  source_dir  = "cloud_functions/trigger_airflow_sync/"
  output_path = "cloud_functions/trigger_airflow_sync.zip"
}
