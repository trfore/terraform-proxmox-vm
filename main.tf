# simple clone of a proxmox template image (e.g. ubuntu-cloud)
resource "proxmox_vm_qemu" "proxmox_vm" {
  for_each    = var.proxmox_vm
  name        = each.value.hostname
  desc        = each.value.hostname
  vmid        = each.value.vm_id
  target_node = each.value.target_node
  clone       = each.value.img_template
  full_clone  = false
  os_type     = "cloud-init"
  memory      = each.value.memory
  cores       = each.value.vcpu
  agent       = 1
  numa        = true

  disk {
    type     = "scsi"
    storage  = "local-lvm"
    size     = each.value.boot_disk_size
    iothread = each.value.boot_disk_iothread
    ssd      = each.value.boot_disk_ssd
    discard  = each.value.boot_disk_discard
  }
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  tablet = false

  # cloud-init settings
  ipconfig0 = "ip=${each.value.cidr},gw=${each.value.NAT_gateway_IPv4}"

  sshkeys = file("${var.ssh_key_public}")

  # block changing mac address on reapply
  # https://github.com/Telmate/terraform-provider-proxmox/issues/112/
  lifecycle {
    ignore_changes = [
      network
    ]
  }
}
