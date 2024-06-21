terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = file("/home/mkljestan/actions-runner/gcp_sa.json")
  project     = "devops-t1-t2"
  region      = "us-central1"
  zone        = "us-central1-a"
}

resource "google_compute_network" "vpc" {
  name                    = "t1-t2-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "t1-t2-subnet" {
  name          = "t1t2-subnet"
  region        = "us-central1"
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.0.0.0/24"
}

# TODO add compute instance admin v1 role and owner
resource "google_service_account" "gke-sa" {
  account_id   = "gke-service-account"
  display_name = "GKE Service Account"
}

resource "google_container_cluster" "marija-cluster" {
  name                     = "gke-cluster"
  location                 = "us-central1"
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "marija_preemptible_nodes" {
  name       = "marija-node-pool"
  location   = "us-central1"
  cluster    = google_container_cluster.marija-cluster.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    service_account = google_service_account.gke-sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
