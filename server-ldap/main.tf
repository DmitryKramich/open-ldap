terraform {
  backend "gcs" {
	credentials = "terraform-admin.json"
    bucket = "dkramich-ldap"
    prefix = "terraform_bucket/"
  }
}

# create network with cloud nat
module "network" {
  source              = "./modules/network"
  project             = var.project            
  region              = var.region  
  student_name        = var.student_name 
  external_ranges     = var.external_ranges
  external_http_ports = var.external_http_ports
  ssh_external_ports  = var.ssh_external_ports 
  ldap_ports          = var.ldap_ports
  internal_ranges     = var.internal_ranges
  public_subnet       = var.public_subnet
  private_subnet      = var.private_subnet
  ldap_tags           = var.ldap_tags
}

# create templates and instance groups
module "instance_group" {
  source                    = "./modules/instance_group"
  project                   = var.project
  region                    = var.region
  zone                      = var.zone
  student_name              = var.student_name
  machine_type              = var.machine_type
  disk_size                 = var.disk_size
  network_custom_vpc        = var.network_custom_vpc
  subnetwork_custom_public  = var.subnetwork_custom_public
  subnetwork_custom_private = var.subnetwork_custom_private
  disk_type                 = var.disk_type
  images                    = var.images
  distribution_zones        = var.distribution_zones
  ldap_replicas             = var.ldap_replicas
  depends_on                = [module.network]
}
 
# create http-lb and conect him to group
module "http_lb" {
  source       = "./modules/http_lb"
  project      = var.project
  region       = var.region
  student_name = var.student_name
  http_port    = var.http_port
  depends_on   = [module.network, module.instance_group]
}
