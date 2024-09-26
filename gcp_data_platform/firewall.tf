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
