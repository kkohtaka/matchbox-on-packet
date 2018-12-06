variable "auth_token" {
  type = "string"
}

variable "packet_project_name" {
  type    = "string"
  default = "matchbox"
}

variable "packet_facility" {
  type    = "string"
  default = "nrt1"
}

provider "packet" {
  auth_token = "${var.auth_token}"
}

resource "packet_project" "project" {
  name = "${var.packet_project_name}"
}

module "matchbox" {
  source = "./matchbox"

  packet_project_id = "${packet_project.project.id}"
  packet_facility   = "${var.packet_facility}"
  ca_cert           = "${file(".matchbox/ca.crt")}"
  server_cert       = "${file(".matchbox/server.crt")}"
  server_key        = "${file(".matchbox/server.key")}"
}
