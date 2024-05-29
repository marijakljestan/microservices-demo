terraform {
  backend "gcs" {
    bucket = "tf-backend-3"
    prefix = "terraform/state"
    credentials = "/home/mkljestan/actions-runner/gcp_sa.json"
  }
}