variable "project" {
	default = "compact-retina-288017"
}

variable "region" {
	default = "us-central1"
}

variable "student_name" {
	default = "dkramich"
}

variable "external_ranges" {
	type    = list
	default = ["0.0.0.0/0"]
}

variable "external_http_ports" {
	type    = list 
	default = ["80"]
}

variable "ssh_external_ports" {
	type    = list 
	default = ["22"]
}

variable "ldap_ports" {
	type    = list
	default = ["389"]
}

variable "internal_ranges" {
	type    = list
	default = ["10.2.0.0/24"]
}

variable "public_subnet" {
	default = "10.2.1.0/24"
}

variable "private_subnet" {
	default = "10.2.2.0/24"
}

variable "ldap_tags" {
	type    = list
	default = ["ldap-client"]
}
