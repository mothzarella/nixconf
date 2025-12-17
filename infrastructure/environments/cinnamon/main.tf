module "sonarqube" {
  source = "../../modules/sonarqube"
  host   = var.host
}

module "portainer" {
  source = "../../modules/portainer"
  host   = var.host
  sock   = var.sock
}
