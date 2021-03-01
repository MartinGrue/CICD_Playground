/* general */
variable "node_count" {
  default = 3
}

/* etcd_node_count must be <= node_count; odd numbers provide quorum */
variable "etcd_node_count" {
  default = 3
}

variable "domain" {
  default = "example.com"
}

variable "hostname_format" {
  default = "kube%d"
}


/* digitalocean */
variable "digitalocean_token" {
  default = ""
}
variable "pub_ssh_key" {
  type = string
}
variable "priv_ssh_key" {
  type = string
}


variable "digitalocean_region" {
  default = "fra1"
}

variable "digitalocean_size" {
  default = "s-1vcpu-2gb"
}

variable "digitalocean_image" {
  default = "ubuntu-20-04-x64"
}

/* packet */

# variable "packet_auth_token" {
#   default = ""
# }

# variable "packet_project_id" {
#   default = ""
# }

# variable "packet_plan" {
#   default = "c1.small.x86"
# }

# variable "packet_facility" {
#   default = "sjc1"
# }

# variable "packet_operating_system" {
#   default = "ubuntu_20_04"
# }

# variable "packet_billing_cycle" {
#   default = "hourly"
# }

# variable "packet_user_data" {
#   default = ""
# }

/* aws dns */
