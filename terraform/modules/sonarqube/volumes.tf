resource "docker_volume" "data" {
  name = "sonarqube_data"
}

resource "docker_volume" "extensions" {
  name = "sonarqube_extensions"
}

resource "docker_volume" "logs" {
  name = "sonarqube_logs"
}
