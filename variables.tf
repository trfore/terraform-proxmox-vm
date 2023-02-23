# Sensitive Variables to Pass as Terrafrom CLI Args
variable "pm_api_token_id" {
  default = ""
}

variable "pm_api_token_secret" {
  default = ""
}

# Sensitive Variables
variable "pm_api_url" {
  description = "Proxmox API Endpoint, e.g. 'https://pve.example.com/api2/json'"
  type        = string
  sensitive   = true
  validation {
    condition     = can(regex("(?i)^https://.*/api2/json$", var.pm_api_url))
    error_message = "Proxmox API Endpoint Invalid. Check URL - HTTPS and PATH req."
  }
}

variable "ssh_key_file" {
  description = "Public SSH Key for VM Host"
  default     = "~/.ssh/id_ed25519.pub"
  type        = string
  sensitive   = true
  validation {
    condition     = can(regex("(?i)PRIVATE", var.ssh_key_file)) == false
    error_message = "ERROR Private SSH Key"
  }
}

# variable "ssh_key_public_admin" {
#   description = "Admin Public SSH Key for VM Host"
#   default     = "~/.ssh/id_ed25519.pub"
#   type        = string
#   sensitive   = true
#   validation {
#     condition     = can(regex("(?i)PRIVATE", var.ssh_key_public_admin)) == false
#     error_message = "ERROR Private SSH Key"
#   }
# }

# variable "ssh_key_public_ansible" {
#   description = "Ansible Public SSH Key for VM Host"
#   default     = "~/.ssh/id_ed25519.pub"
#   type        = string
#   sensitive   = true
#   validation {
#     condition     = can(regex("(?i)PRIVATE", var.ssh_key_public_ansible)) == false
#     error_message = "ERROR Private SSH Key"
#   }
# }

variable "DNS_searchdomain" {
  description = "Internal DNS Server, e.g. 'dns.example.com'"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.DNS_searchdomain) != 0
    error_message = "DNS URL required"
  }
}

# Default Variables
variable "vm_user" {
  description = "default user for VMs"
  default     = "ubuntu"
}

variable "proxmox_vm" {
  description = "VM settings, hostname must be alphanumeric, may contain `-`"
  type        = map(any)
  default = {
    "vm-1000" = {
      vm_id              = 0,
      hostname           = "vm-1000",
      target_node        = "lab1",
      img_template       = "ubuntu-cloud",
      vcpu               = "2",
      memory             = "4096",
      boot_disk_size     = "10G",
      boot_disk_iothread = 0,
      boot_disk_ssd      = 0,
      boot_disk_discard  = "ignore", # "on" = ssd trim
      cidr               = "192.168.1.254/24",
      NAT_gateway_IPv4   = "192.168.1.1",
      vnic_bridge        = "vmbr0",
      vlan_tag           = 1
    }
  }
}
