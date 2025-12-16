module "sonarqube" {
  source    = "/home/tar/nixconf/infrastructure/sonarqube"
  localhost = var.localhost
}

module "portainer" {
  source    = "/home/tar/nixconf/infrastructure/portainer"
  localhost = var.localhost
  sock      = var.sock
}
