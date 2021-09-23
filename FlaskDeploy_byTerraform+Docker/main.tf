terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}
provider "docker" {}
###########################################
# Network
resource "docker_network" "flask_network" {
  name = "flask_network"
}
# Volume
resource "docker_volume" "postgres_data" {
  name = "postgres_data"
}
###########################################
# Run WEB image
resource "docker_image" "flaskappweb" {
  name         = "vvborys/flaskappweb:latest"
  keep_locally = false
}

resource "docker_container" "web" {
  image = docker_image.flaskappweb.latest
  name  = "web"
  restart = "always"
  env = ["DEBUG=1"]
  ports {
    internal = 5000
    external = 5000
  }
}

# Run PROXY image #######################
resource "docker_image" "flaskappproxy" {
  name         = "vvborys/flaskappproxy:latest"
  keep_locally = false
}

resource "docker_container" "proxy" {
  image = docker_image.flaskappproxy.latest
  name  = "proxy"
  restart = "always"
  ports {
    internal = 80
    external = 80
  }
}

# Run POSTGRES image ####################
resource "docker_image" "postgres" {
  name         = "postgres:latest"
  keep_locally = false
}

resource "docker_container" "postgres" {
  image = docker_image.postgres.latest
  name  = "db"
  restart = "always"
  ports {
    internal = 5432
    external = 5432
  }
  env = ["POSTGRES_USER=admin", "POSTGRES_PASSWORD=admin", "POSTGRES_DB=market" ]
  volumes {
    volume_name = "docker_volume.postgres_data"
  }
}
