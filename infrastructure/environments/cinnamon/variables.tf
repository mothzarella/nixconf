variable "host" {
  type    = string
  default = "127.0.0.1"
}

variable "sock" {
  type        = string
  description = "entry point for Docker API"
  default     = "/var/run/docker.sock"
}

variable "ports" {
  type = list(object({
    internal = number
    external = number
    protocol = string
  }))
  description = "list of port configurations for Docker containers."
  default = [
    {
      internal = 0000
      external = 0000
      protocol = "tcp"
    }
  ]
}
