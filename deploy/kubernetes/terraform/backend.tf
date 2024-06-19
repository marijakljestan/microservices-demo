terraform {
  backend "gcs" {
    bucket = "t1-t2-tf-backend"
    prefix = "terraform/state"
    credentials = "/home/mkljestan/actions-runner/gcp_sa.json"
  }
}