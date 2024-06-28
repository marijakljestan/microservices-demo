variable "name" {
  description = "Name of the subnet"
  type = string
}

variable "region" {
  description = "Region where subnet will be placed"
  type = string
}

variable "network" {
  description = "ID of VPC network where subnet will be created"
  type = string
}
variable "ip_cidr_range" {
  description = "IP CIDR range of the subnet"
  type = string
}