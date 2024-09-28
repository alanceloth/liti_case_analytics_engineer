resource "google_storage_bucket" "data_lake" {
  name                        = "data-lake-bucket-${var.project}"
  location                    = var.region
  force_destroy               = true
  uniform_bucket_level_access = true
  storage_class               = "STANDARD" # Classe padrão

  labels = {
    name       = "data-lake-bucket-${var.project}"
    managed-by = "terraform"
  }
}

resource "google_storage_bucket" "airflow_dags" {
  name                        = "airflow-dags-bucket-${var.project}"
  location                    = var.region
  force_destroy               = true
  uniform_bucket_level_access = true
  storage_class               = "STANDARD" # Classe padrão

  labels = {
    name       = "airflow-dags-bucket-${var.project}"
    managed-by = "terraform"
  }
}

resource "google_storage_bucket" "functions_bucket" {
  name          = "${var.project}-functions-code"
  location      = var.region
  force_destroy = true
}

resource "google_storage_bucket_object" "function_zip" {
  name   = "trigger_airflow_sync.zip"
  bucket = google_storage_bucket.functions_bucket.name
  source = data.archive_file.trigger_airflow_sync_zip.output_path
}


