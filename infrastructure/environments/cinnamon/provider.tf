provider "docker" {
  host = "unix://${var.sock}"
}
