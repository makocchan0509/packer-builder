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

variable "image_name" {
  type = string
}

variable "use_internal_ip" {
  type = bool
  default = false
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
  image_name                  = var.image_name
  machine_type                = "e2-micro"
  tags                        = ["packer"]
  impersonate_service_account = var.builder_sa
  startup_script_file         = "startup-script.sh"
  use_internal_ip             = var.use_internal_ip
}

build {
  sources = ["sources.googlecompute.test-image"]
}