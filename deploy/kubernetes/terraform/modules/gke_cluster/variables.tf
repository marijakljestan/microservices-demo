variable "name" {
  description = "Name of the GKE cluster"
  type = string
}

variable "location" {
  description = "Region or zone where cluster will be created"
  type = string
}

variable "network" {
  description = "VPC (name or self-link) where cluster will be created"
  type = string
}

variable "subnetwork" {
  description = "Subnet (name or self-link) where cluster will be created"
}