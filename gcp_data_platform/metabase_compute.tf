resource "google_compute_instance" "metabase_instance" {
  name         = "metabase-instance"
  machine_type = "f1-micro"
  zone         = var.zone

  # Adicionando labels
  labels = {
    name       = "metabase_instance"
    managed-by = "terraform"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 10
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet.id

    access_config {}
  }

  service_account {
    email  = google_service_account.metabase_sa.email
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = file("scripts/metabase_startup.sh")
}
