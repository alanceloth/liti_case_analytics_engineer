terraform {
  required_version = ">= 0.13"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.5"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}
provider "archive" {}


resource "google_project_service" "secretmanager" {
  service = "secretmanager.googleapis.com"
  project = var.project
}

resource "google_project_service" "pubsub" {
  service = "pubsub.googleapis.com"
  project = var.project
}

resource "google_project_service" "cloudfunctions" {
  service = "cloudfunctions.googleapis.com"
  project = var.project
}

resource "google_project_service" "artifactregistry" {
  service = "artifactregistry.googleapis.com"
  project = var.project
}

resource "google_project_service" "cloudbuild" {
  service = "cloudbuild.googleapis.com"
  project = var.project
}