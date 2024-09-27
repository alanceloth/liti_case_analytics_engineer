# Criação do tópico Pub/Sub
resource "google_pubsub_topic" "vm_status_topic" {
  name = "vm-status-topic"
}

# Criação da assinatura do tópico
resource "google_pubsub_subscription" "vm_status_subscription" {
  name  = "vm-status-subscription"
  topic = google_pubsub_topic.vm_status_topic.name
}

# Conceder permissões para a conta de serviço do Airbyte
resource "google_project_iam_member" "airbyte_pubsub_publisher" {
  project = var.project
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.airbyte_sa.email}"
}

# Conceder permissões para a conta de serviço do Airflow
resource "google_project_iam_member" "airflow_pubsub_publisher" {
  project = var.project
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.airflow_sa.email}"
}

# Conceder permissões para a conta de serviço do Metabase
resource "google_project_iam_member" "metabase_pubsub_publisher" {
  project = var.project
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.metabase_sa.email}"
}

# Conceder permissões para a conta de serviço do MongoDB
resource "google_project_iam_member" "mongodb_pubsub_publisher" {
  project = var.project
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.mongodb_sa.email}"
}
