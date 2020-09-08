provider "google" {
  credentials = "terraform-admin.json"
  project     = var.project
  region      = var.region
}