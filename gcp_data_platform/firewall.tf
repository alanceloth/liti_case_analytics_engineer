resource "google_compute_firewall" "allow_internal" {
  name    = "allow-internal"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  source_ranges = ["10.0.0.0/16"]
}

resource "google_compute_firewall" "allow_ssh_http" {
  name    = "allow-ssh-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "8000", "8080", "3000"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_mongodb_internal" {
  name    = "allow-mongodb-internal"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }

  source_tags = ["airbyte", "airflow"]
  target_tags = ["mongodb"]
}

resource "google_compute_firewall" "allow_airflow" {
  name    = "allow-airflow"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"] # Em produção, restrinja ao seu IP

  target_tags = ["airflow"] # Aplica-se a instâncias com a tag 'airflow'
}

