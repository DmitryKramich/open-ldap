provider "google" {
  credentials = "terraform-admin.json"
  project     = var.project
  region      = var.region
}

# create server
resource "google_compute_instance" "lpad_server" {
  name            = "ldap-server"
  can_ip_forward  = true
  machine_type    = var.machine_type
  zone            = var.zone
  tags            = var.ldap_tags 
  
  boot_disk {
    initialize_params {
	  size  = var.disk_size
	  type  = var.disk_type
	  image = var.images
    }
  }
  
  metadata_startup_script = templatefile("ldap+gui.sh", {
    key = "${var.pubkey}" })
  
  network_interface {
	network    = var.network_custom_vpc
    subnetwork = var.subnetwork_custom_public
    access_config {}
  }
}

locals {
  srv_ldap_ip = google_compute_instance.lpad_server.network_interface.0.network_ip
}

# create client
resource "google_compute_instance" "lpad_client" {
  name         = "lpad-client"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = var.ldap_cli_tags

  boot_disk {
    initialize_params {
	  size  = var.disk_size
	  type  = var.disk_type
	  image = var.images
    }
  }
    metadata_startup_script = templatefile("client-ldap.sh", {
    ldap_ip = "${local.srv_ldap_ip}" })
	
  network_interface {
	network    = var.network_custom_vpc
    subnetwork = var.subnetwork_custom_public
	access_config {}
  }
}

