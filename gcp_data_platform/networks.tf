resource "google_compute_network" "vpc_network" {
  name                    = "data-platform-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "data-platform-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_address" "metabase_ip" {
  name   = "metabase-ip"
  region = var.region
}

resource "google_compute_address" "airbyte_ip" {
  name   = "airbyte-ip"
  region = var.region
}

resource "google_compute_address" "airflow_ip" {
  name   = "airflow-ip"
  region = var.region
}