project       = "compact-retina-288017"
region        = "us-central1"
zone          = "us-central1-c"
machine_type  = "custom-1-4608"
disk_type     = "pd-ssd"
disk_size     = 35
images        = "centos-cloud/centos-7"

#network options 
student_name          = "dk"
external_http_ports   = ["80","443"]
ssh_external_ports    = ["22"]
external_ranges       = ["0.0.0.0/0"]
ldap_ports            = ["389"]
internal_ranges       = ["10.2.0.0/24"]
public_subnet         = "10.2.1.0/24"
private_subnet        = "10.2.2.0/24"
ldap_tags             = ["ldap-srv"]

#network for bastion, templates, tcp-lb
network_custom_vpc        = "dk-vpc"
subnetwork_custom_public  = "public-subnet"
subnetwork_custom_private = "private-subnet"

#templates options
distribution_zones = ["us-central1-a", "us-central1-b", "us-central1-c"]
http_port          = "80"
ldap_replicas      = "1"
