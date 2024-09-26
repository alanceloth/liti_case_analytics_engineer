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

# Repeat for airflow_sa and metabase_sa with appropriate roles
