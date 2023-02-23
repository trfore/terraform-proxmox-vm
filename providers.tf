terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.11"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.pm_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_log_enable       = false
  pm_log_file         = "terraform-plugin-proxmox.log"
  pm_debug            = false
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}
