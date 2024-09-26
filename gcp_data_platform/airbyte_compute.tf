resource "google_compute_instance" "airbyte_instance" {
  name         = "airbyte-instance"
  machine_type = "e2-standard-2" # Tipo de máquina menor
  zone         = var.zone

  # Adicionando labels
  labels = {
    name       = "airbyte_instance"
    managed-by = "terraform"
  }

  tags = ["airbyte", "terraform"]
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 20 # Tamanho mínimo do disco
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet.id

    access_config {}
  }

  service_account {
    email  = google_service_account.airbyte_sa.email
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = file("scripts/airbyte_startup.sh")
}
