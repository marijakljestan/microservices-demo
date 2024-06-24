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
  routing_mode = "GLOBAL"
}

resource "google_compute_subnetwork" "dev-subnet" {
  name          = "dev-subnet"
  region        = "us-east1"
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.0.0.0/24"
}

resource "google_compute_subnetwork" "stage-subnet" {
  name          = "stage-subnet"
  region        = "us-west1"
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.0.1.0/24"
}

resource "google_compute_subnetwork" "prod-subnet" {
  name          = "prod-subnet"
  region        = "us-central1"
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.0.2.0/24"
}

resource "google_service_account" "gke-sa" {
  account_id   = "gke-service-account"
  display_name = "GKE Service Account"
}

resource "google_container_cluster" "dev-cluster" {
  name                     = "dev-cluster"
  location                 = "us-east1"
  network = google_compute_network.vpc.self_link
  subnetwork = google_compute_subnetwork.dev-subnet.self_link
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "dev_preemptible_nodes" {
  name       = "dev-node-pool"
  location   = "us-east1"
  cluster    = google_container_cluster.dev-cluster.name
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

resource "google_container_cluster" "stage-cluster" {
  name                     = "stage-cluster"
  location                 = "us-west1"
  network = google_compute_network.vpc.self_link
  subnetwork = google_compute_subnetwork.stage-subnet.self_link
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "stage_preemptible_nodes" {
  name       = "stage-node-pool"
  location   = "us-west1"
  cluster    = google_container_cluster.stage-cluster.name
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

resource "google_container_cluster" "prod-cluster" {
  name                     = "prod-cluster"
  location                 = "us-central1"
  network = google_compute_network.vpc.self_link
  subnetwork = google_compute_subnetwork.prod-subnet.self_link
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "prod_preemptible_nodes" {
  name       = "prod-node-pool"
  location   = "us-central1"
  cluster    = google_container_cluster.prod-cluster.name
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