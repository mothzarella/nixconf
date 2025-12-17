locals {
  ports = [
    {
      internal = 9000,
      external = 9000
    }
  ]

  volumes = [
    {
      volume_name    = docker_volume.data.name,
      container_path = "/opt/sonarqube/data"
    },
    {
      volume_name    = docker_volume.extensions.name,
      container_path = "/opt/sonarqube/extensions"
    },
    {
      volume_name    = docker_volume.logs.name,
      container_path = "/opt/sonarqube/logs"
    }
  ]
}

resource "docker_image" "sonarqube" {
  name         = "sonarqube:community"
  keep_locally = false
}

resource "docker_container" "sonarqube" {
  image = docker_image.sonarqube.image_id
  name  = "sonarqube"

  restart = "unless-stopped"

  dynamic "ports" {
    for_each = local.ports
    content {
      internal = ports.value.internal
      external = ports.value.external
      ip       = var.host
      protocol = "tcp"
    }
  }

  dynamic "volumes" {
    for_each = local.volumes
    content {
      volume_name    = volumes.value.volume_name
      container_path = volumes.value.container_path
    }
  }
}
