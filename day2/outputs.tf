output "ldap-server" {
  value = "http://${google_compute_instance.lpad_server.network_interface.0.access_config.0.nat_ip}/ldapadmin/"
}
output "ldap-client" {
  value = "${google_compute_instance.lpad_client.network_interface.0.access_config.0.nat_ip}"
}