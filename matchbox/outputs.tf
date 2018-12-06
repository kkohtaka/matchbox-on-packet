output "access_public_ipv4" {
  value = "${cidrhost(packet_reserved_ip_block.matchbox.cidr_notation, 0)}"
}
