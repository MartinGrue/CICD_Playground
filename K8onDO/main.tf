module "provider" {
  source = "./provider/digitalocean"

  token           = var.digitalocean_token
  pub_ssh_key     = var.pub_ssh_key
  priv_ssh_key    = var.priv_ssh_key
  region          = var.digitalocean_region
  size            = var.digitalocean_size
  image           = var.digitalocean_image
  hosts           = var.node_count
  hostname_format = var.hostname_format
}

module "swap" {
  source = "./services/swap"

  node_count   = var.node_count
  connections  = module.provider.public_ips
  priv_ssh_key = module.provider.priv_ssh_key
}

# module "dns" {
#   source = "./dns/cloudflare"

#   node_count = var.node_count
#   email      = var.cloudflare_email
#   api_token  = var.cloudflare_api_token
#   domain     = var.domain
#   public_ips = module.provider.public_ips
#   hostnames  = module.provider.hostnames
# }
module "wireguard" {
  source = "./security/wireguard"

  node_count   = var.node_count
  connections  = module.provider.public_ips
  priv_ssh_key = module.provider.priv_ssh_key
  private_ips  = module.provider.private_ips
  hostnames    = module.provider.hostnames
  # overlay_cidr = module.kubernetes.overlay_cidr
}

module "firewall" {
  source = "./security/ufw"

  node_count   = var.node_count
  connections  = module.provider.public_ips
  priv_ssh_key = module.provider.priv_ssh_key
  private_interface    = module.provider.private_network_interface
  vpn_interface        = module.wireguard.vpn_interface
  vpn_port             = module.wireguard.vpn_port
  # kubernetes_interface = module.kubernetes.overlay_interface
}

module "etcd" {
  source = "./services/etcd"

  node_count   = var.etcd_node_count
  connections  = module.provider.public_ips
  priv_ssh_key = module.provider.priv_ssh_key
  hostnames    = module.provider.hostnames
  vpn_unit     = module.wireguard.vpn_unit
  vpn_ips      = module.wireguard.vpn_ips
}

module "kubernetes" {
  source = "./services/kubernetes"

  node_count     = var.node_count
  connections    = module.provider.public_ips
  priv_ssh_key   = module.provider.priv_ssh_key
  cluster_name   = var.domain
  vpn_interface  = module.wireguard.vpn_interface
  vpn_ips        = module.wireguard.vpn_ips
  etcd_endpoints = module.etcd.endpoints
}
