resource "digitalocean_droplet" "JenkinsDocker" {
  image              = "ubuntu-18-04-x64"
  name               = "JenkinsDocker"
  region             = "fra1"
  size               = "s-1vcpu-1gb"
  private_networking = true
  ssh_keys           = [data.digitalocean_ssh_key.main.id]
  # connection {
  #   host        = self.ipv4_address
  #   user        = "root"
  #   type        = "ssh"
  #   private_key = file(var.pvt_key)
  #   timeout     = "2m"
  # }
  provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt install python -y", "echo Done!"]

    connection {
      host        = self.ipv4_address
      type        = "ssh"
      user        = "root"
      private_key = file(var.pvt_key)
    }
  }
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},' --private-key ${var.pvt_key} apache-install.yml"
  }
  # provisioner "local-exec" {
  #   command = "ansible-playbook -u root -i '${self.public_ip},' --private-key ${var.pvt_key} ../ansible/jenkins.yml"
  # }
  # provisioner "remote-exec" {
  #   inline = [
  #     "export PATH=$PATH:/usr/bin",
  #     # install ansible
  #     "sudo apt-get update",
  #     "sudo apt-get -y install nginx"
  #   ]
  # }
}
