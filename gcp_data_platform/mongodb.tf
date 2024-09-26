resource "google_compute_instance" "mongodb_instance" {
  name         = "mongodb-instance"
  machine_type = "e2-micro" # Máquina pequena para o free tier
  zone         = var.zone

  labels = {
    name       = "mongodb_instance"
    managed-by = "terraform"
  }

  tags = ["mongodb", "terraform"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 10 # Tamanho mínimo do disco
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet.id

    access_config {}
  }

  service_account {
    email  = google_service_account.mongodb_sa.email
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = file("scripts/mongodb_startup.sh")
}
