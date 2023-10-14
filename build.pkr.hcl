packer {
  required_plugins {
    googlecompute = {
      version = ">= 1.1.1"
      source = "github.com/hashicorp/googlecompute"
    }
  }
}

variable "project_id" {
  type = string
}

variable "zone" {
  type = string
}

variable "builder_sa" {
  type = string
}

source "googlecompute" "test-image" {
  project_id                  = var.project_id
  source_image_family         = "ubuntu-2204-lts"
  zone                        = var.zone
  image_description           = "Created with HashiCorp Packer from Cloudbuild"
  ssh_username                = "packer"
  disk_size                   = "10"
  network                     = "packer-network"
  subnetwork                  = "packer-tokyo"
  image_name                  = var.iamge_name
  machine_type                = "e2-micro"
  tags                        = ["packer"]
  impersonate_service_account = var.builder_sa
  startup_script_file         = "startup-script.sh"
}

build {
  sources = ["sources.googlecompute.test-image"]
}