terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}

# Configiure the Docker provider
provider "docker" {}

# Create Container
resource "docker_container" "lss" {
  user = "root:root"
  image = docker_image.lss.latest
  name  = "lss"
  ports {
    internal = 8080
    external = 8002
  }
  user = "root:root"

# Mount LSS_DATA_DIR
volumes {
  container_path = "/usr/local/parasoft/license-server/data"
  host_path = "/home/ec2-user/parasoft/terraform/lss/lss-data"
  read_only = false
  }

# Mount docker.sock
volumes {
  container_path = "/var/run/docker.sock"
  host_path = "/var/run/docker.sock"
  read_only = false
}

# Mount parasoft-volume
volumes {
  volume_name = "parasoft-volume"
  container_path = "/mnt/parasoft"
  read_only = false
}
}


# Deps
# LSS Docker Image resource definition
resource "docker_image" "lss" {
  name         = "parasoft/lss:latest"
  keep_locally = true
}

# LSS parasoft-volume
resource "docker_volume" "parasoft_volume" {
    name = "parasoft-volume"
}
