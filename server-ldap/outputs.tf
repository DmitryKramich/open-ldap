output "web_site" {
  value = "http://${module.http_lb.ldap}/ldapadmin/"
}
