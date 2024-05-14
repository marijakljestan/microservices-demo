terraform {
  backend "gcs" {
    bucket = "tf-backend-2"
    prefix = "terraform/state"
  }
}