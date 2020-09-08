# group of virtual machine instances

data "google_compute_region_instance_group" "ldap_srv_group" {
  name                 = "ldap-srv-group"
}

# used to forward traffic to the correct load balancer for HTTP load balancing 

resource "google_compute_global_forwarding_rule" "global_forwarding_rule" {
  name       = "global-forwarding-rule"
  project    = var.project
  target     = google_compute_target_http_proxy.target_http_proxy.self_link
  port_range = var.http_port
}

# used by one or more global forwarding rule to route incoming HTTP requests to a URL map

resource "google_compute_target_http_proxy" "target_http_proxy" {
  name    = "proxy"
  project = var.project
  url_map = google_compute_url_map.url_map.self_link
}

# used to route requests to a backend service based on rules that you define for the host and path of an incoming URL

resource "google_compute_url_map" "url_map" {
  name            = "region-map"
  default_service = google_compute_backend_service.backend_service.id
}

# defines a group of virtual machines that will serve traffic for load balancing

resource "google_compute_backend_service" "backend_service" {
  name                    = "${var.student_name}-backend-service"
  port_name               = "http"
  protocol                = "HTTP"
  load_balancing_scheme   = "EXTERNAL"
  health_checks           = [google_compute_health_check.healthcheck.id]
  
  backend {
    group                 = data.google_compute_region_instance_group.ldap_srv_group.id
    balancing_mode        = "RATE"
    max_rate_per_instance = 100
  }
}

# determine whether lb are responsive and able to do work

resource "google_compute_health_check" "healthcheck" {
  name               = "tcp-healthcheck"
  timeout_sec        = 1
  check_interval_sec = 1
  tcp_health_check {
    port = var.http_port
  }
}

