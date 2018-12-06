resource "packet_reserved_ip_block" "matchbox" {
  project_id = "${var.packet_project_id}"
  facility   = "${var.packet_facility}"
  quantity   = 1
}

resource "packet_device" "matchbox" {
  hostname         = "matchbox"
  plan             = "t1.small.x86"
  facility         = "${var.packet_facility}"
  operating_system = "coreos_stable"
  billing_cycle    = "hourly"
  project_id       = "${var.packet_project_id}"
  tags             = ["matchbox"]
  user_data        = "${data.ignition_config.matchbox.rendered}"
}

resource "packet_ip_attachment" "matchbox" {
  device_id     = "${packet_device.matchbox.id}"
  cidr_notation = "${cidrhost(packet_reserved_ip_block.matchbox.cidr_notation, 0)}/32"
}
