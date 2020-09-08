output "network-name" {
  value = google_compute_network.vpc_network.name
}

output "subnetwork-public-name" {
  value = google_compute_subnetwork.public.name
}

output "subnetwork-private-name" {
  value = google_compute_subnetwork.private.name
}