output "airbyte_external_ip" {
  value = google_compute_instance.airbyte_instance.network_interface[0].access_config[0].nat_ip
}

output "airflow_external_ip" {
  value = google_compute_instance.airflow_instance.network_interface[0].access_config[0].nat_ip
}

output "metabase_external_ip" {
  value = google_compute_instance.metabase_instance.network_interface[0].access_config[0].nat_ip
}

# output "mongodb_internal_ip" {
#   value = google_compute_instance.mongodb_instance.network_interface[0].network_ip
# }

output "mongodb_external_ip" {
  value = google_compute_instance.metabase_instance.network_interface[0].access_config[0].nat_ip
}
