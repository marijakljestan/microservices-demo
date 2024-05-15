terraform {
  backend "gcs" {
    bucket = "tf-backend-3"
    prefix = "terraform/state"
  }
}