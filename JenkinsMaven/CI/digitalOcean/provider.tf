terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "1.22.2"
    }
  }
}

variable "do_token" {}
variable "ssh_key" {
  type = string
}
variable "region" {
  type    = string
  default = "fra1"
}
variable "droplet_count" {
  type    = number
  default = 1
}
variable "droplet_size" {
  type    = string
  default = "s-1vcpu-1gb"
}
variable "pvt_key" {
  type    = string
  default = "/home/gruma/.ssh/id_rsa"
}
provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "main" {
  name = var.ssh_key
}
