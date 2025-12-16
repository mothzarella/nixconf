resource "docker_volume" "sonarqube_data" {
  name = "sonarqube_data"
}

resource "docker_volume" "sonarqube_extensions" {
  name = "sonarqube_extensions"
}

resource "docker_volume" "sonarqube_logs" {
  name = "sonarqube_logs"
}
