data "ignition_config" "matchbox" {
  systemd = [
    "${data.ignition_systemd_unit.matchbox.id}",
  ]

  files = [
    "${data.ignition_file.matchbox-override-conf.id}",
    "${data.ignition_file.matchbox-ca-crt.id}",
    "${data.ignition_file.matchbox-server-crt.id}",
    "${data.ignition_file.matchbox-server-key.id}",
  ]

  networkd = [
    "${data.ignition_networkd_unit.matchbox-loopback.id}",
  ]
}

data "ignition_systemd_unit" "matchbox" {
  name    = "matchbox.service"
  content = "${file("${path.module}/files/matchbox.service")}"
}

data "ignition_file" "matchbox-override-conf" {
  filesystem = "root"
  path       = "/etc/systemd/system/matchbox.service.d/override.conf"

  content {
    content = "${file("${path.module}/files/matchbox-override.conf")}"
  }
}

data "ignition_file" "matchbox-ca-crt" {
  filesystem = "root"
  path       = "/etc/matchbox/ca.crt"

  content {
    content = "${var.ca_cert}}"
  }
}

data "ignition_file" "matchbox-server-crt" {
  filesystem = "root"
  path       = "/etc/matchbox/server.crt"

  content {
    content = "${var.server_cert}}"
  }
}

data "ignition_file" "matchbox-server-key" {
  filesystem = "root"
  path       = "/etc/matchbox/server.key"

  content {
    content = "${var.server_key}}"
  }
}

data "ignition_networkd_unit" "matchbox-loopback" {
  name    = "10-loopback.network"
  content = "[Match]\nName=lo\n\n[Network]\nAddress=127.0.0.1/24\nAddress=${packet_reserved_ip_block.matchbox.cidr_notation}"
}
