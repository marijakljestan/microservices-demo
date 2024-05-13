terraform {
  backend "gcs" {
    bucket = "tf-backend-t2"
    prefix = "terraform/state"
 }
}