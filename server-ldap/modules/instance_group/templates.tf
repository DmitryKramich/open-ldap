# create template for our servers

resource "google_compute_instance_template" "lpad_server" {
  name                 = "ldap-server-template"
  description          = "This template is used to create OpenLdap server"
  instance_description = "OpenLdap server running apache"
  can_ip_forward       = true
  machine_type         = var.machine_type
  tags = ["ldap-srv"]
  scheduling {
    automatic_restart = true
  }
  
  disk {
    source_image = var.images
    auto_delete  = true
    boot         = true
  }
  
  network_interface {
	network    = var.network_custom_vpc
    subnetwork = var.subnetwork_custom_public
  }
  
  lifecycle {
    create_before_destroy = true
  }

  metadata_startup_script = file("ldap+gui.sh")
}


# creates a group of virtual machine lpad_server

resource "google_compute_region_instance_group_manager" "ldap_srv_group" {
  name                      = "ldap-srv-group"
  base_instance_name        = "ldap-srv"
  region                    = var.region
  distribution_policy_zones = var.distribution_zones 
  version {
    instance_template = google_compute_instance_template.lpad_server.id
  }
  target_size  = var.ldap_replicas
}

