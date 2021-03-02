resource "digitalocean_droplet" "JenkinsDocker" {
  image              = "debian-9-x64"
  name               = "JenkinsDocker"
  region             = "fra1"
  size               = "s-1vcpu-1gb"
  private_networking = true
  ssh_keys           = [data.digitalocean_ssh_key.main.id]

  provisioner "remote-exec" {
    inline = ["sudo apt update",
      "DEBIAN_FRONTEND=noninteractive apt-get install -yq python3 gpg apt-transport-https ca-certificates",
    "echo Done!"]

    connection {
      host        = self.ipv4_address
      type        = "ssh"
      user        = "root"
      private_key = file(var.pvt_key)
    }
  }
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},' --private-key ${var.pvt_key} ../ansible/jenkins.yml"
  }

}
