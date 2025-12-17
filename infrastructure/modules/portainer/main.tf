locals {
  ports = [
    { internal = 9443, external = 9443 },
    { internal = 8000, external = 8000 }
  ]
}

resource "docker_image" "portainer" {
  name         = "portainer/portainer-ce:alpine"
  keep_locally = false
}

resource "docker_container" "portainer" {
  image = docker_image.portainer.image_id
  name  = "portainer"

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

  volumes {
    volume_name    = docker_volume.portainer_data.name
    container_path = "/data"
  }

  volumes {
    host_path      = var.sock
    container_path = var.sock
  }
}

resource "docker_volume" "portainer_data" {
  name = "portainer_data"
}
