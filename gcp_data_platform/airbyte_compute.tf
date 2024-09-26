resource "google_compute_instance" "airbyte_instance" {
  name         = "airbyte-instance"
  machine_type = "f1-micro" # Tipo de máquina menor
  zone         = var.zone

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
    email  = google_service_account.airbyte_sa.email
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = file("scripts/airbyte_startup.sh")
}
