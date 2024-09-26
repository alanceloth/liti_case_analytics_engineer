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
