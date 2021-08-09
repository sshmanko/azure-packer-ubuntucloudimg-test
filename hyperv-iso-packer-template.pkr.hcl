source "hyperv-iso" "ubuntu_20_cloudimg" {
  disk_block_size = 1
  cd_files          = [ "./files/meta-data", "./files/user-data" ]
  cd_label          = "cidata"
  generation        = 2
  iso_checksum      = "file:D:\isochecksum"
  iso_url           = "focal-server-cloudimg-amd64.vhdx"
  iso_target_extension = "vhdx"
  output_directory  = "output"
  ssh_username      = "rf"
  ssh_timeout       = "10m"
  switch_name       = "vSwitch"
  vm_name           = "packer-vm"
  shutdown_command  = "echo 'packer' | sudo -S shutdown -P now"
}

build {
  sources = ["source.hyperv-iso.ubuntu_20_cloudimg"]

  provisioner "shell" {
    expect_disconnect = true
    inline = [
      "while ! dpkg --status whois 2>/dev/null >/dev/null; do echo 'Waiting 2 minutes for package install to complete'; sleep 120; done"
    ]
  }
}
