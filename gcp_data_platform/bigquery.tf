resource "google_bigquery_dataset" "data_warehouse" {
  dataset_id                  = "data_warehouse"
  location                    = var.region
  friendly_name               = "Data Warehouse"
  description                 = "Dataset BigQuery para data warehouse"
  default_table_expiration_ms = null
}
