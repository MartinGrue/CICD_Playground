terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "1.22.2"
    }
  }
}

variable "token" {}

variable "hosts" {
  default = 0
}

variable "pub_ssh_key" {
  type = string
}
variable "priv_ssh_key" {
  type = string
}
data "digitalocean_ssh_key" "main" {
  name = var.pub_ssh_key
}

variable "hostname_format" {
  type = string
}

variable "region" {
  type = string
}

variable "image" {
  type = string
}

variable "size" {
  type = string
}

variable "apt_packages" {
  type    = list(any)
  default = []
}

provider "digitalocean" {
  token = var.token
}

resource "digitalocean_droplet" "host" {
  name               = format(var.hostname_format, count.index + 1)
  region             = var.region
  image              = var.image
  size               = var.size
  backups            = false
  private_networking = true
  ssh_keys           = [data.digitalocean_ssh_key.main.id]

  count = var.hosts

  connection {
    host        = self.ipv4_address
    private_key = file(var.priv_ssh_key)
    user        = "root"
    type        = "ssh"
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "until [ -f /var/lib/cloud/instance/boot-finished ]; do sleep 1; done",
      "apt-get update",
      "apt-get install -yq ufw ${join(" ", var.apt_packages)}",
    ]
  }
}

output "hostnames" {
  value = digitalocean_droplet.host.*.name
}

output "public_ips" {
  value = digitalocean_droplet.host.*.ipv4_address
}

output "private_ips" {
  value = digitalocean_droplet.host.*.ipv4_address_private
}

output "private_network_interface" {
  value = "eth1"
}
output "priv_ssh_key" {
  value = var.priv_ssh_key
}
