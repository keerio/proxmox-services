resource "proxmox_lxc" "bazarr" {
  target_node  = "pve"
  hostname     = "bazarr"
  ostemplate   = "local:vztmpl/ubuntu-20.10-standard_20.10-1_amd64.tar.gz"
  unprivileged = true
  ostype = "ubuntu"
  ssh_public_keys = file(var.pub_ssh_key)
  start = true
  onboot = true
  vmid = var.bazarr_lxcid
  memory = 1024

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-lvm"
    size    = "4G"
  }

  mountpoint {
    mp      = "/var/lib/bazarr"
    size    = "8G"
    slot    = 0
    key     = "0"
    storage = "/mnt/storage/appdata/bazarr/config"
    volume  = "/mnt/storage/appdata/bazarr/config"
  }

  mountpoint {
    mp      = "/mnt/storage/media"
    size    = "8G"
    slot    = 1
    key     = "1"
    storage = "/mnt/storage/media"
    volume  = "/mnt/storage/media"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    gw     = var.gateway_ip
    ip     = var.bazarr_ip
    ip6    = "auto"
    hwaddr = var.bazarr_mac
  }

  lifecycle {
    ignore_changes = [
      mountpoint[0].storage,
      mountpoint[1].storage
    ]
  }
}