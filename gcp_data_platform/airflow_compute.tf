resource "google_compute_instance" "airflow_instance" {
  name         = "airflow-instance"
  machine_type = "e2-standard-2"
  zone         = var.zone
  
  # Adicionando labels
  labels = {
    name       = "airflow_instance"
    managed-by = "terraform"
  }

  # Adicionando tags
  tags = ["airflow", "terraform"]


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
    email  = google_service_account.airflow_sa.email
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = file("scripts/airflow_startup.sh")
}
