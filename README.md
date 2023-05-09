# Create Proxmox VM using Terraform

## Overview

- This template uses the 3rd party Terraform provider, Telemate/Proxmox, (links: [Telemate/Proxmox - Docs], [Telemate/Proxmox - Github]).
- NOTE: The following Telemate/Proxmox environment variables are not properly recognized and replaced to allow for the use of env vars or in-line vars.
  - `PM_API_TOKEN_ID` is replaced by `TF_VAR_pm_api_token_id`
  - `PM_API_TOKEN_SECRET` is replaced by `TF_VAR_pm_api_token_secret`

## Plan a Deployment - Overview

1. Install Terraform (link: [Terraform - Download])
2. Clone this repo and `cd` into the directory
3. Configure the `terraform.tfvars` file, a **example is provided** `terraform.tfvars.j2`.
4. Initialize the Terraform Proxmox provider `terraform init`
5. Set variables using: ENV vars **OR** CLI in-line args.
6. Run `terraform plan -out tfplan` **OR** see 'In-line Vars' section for a example using `-var` flag.
7. Run `terraform apply 'tfplan'`

### Using Environment Variables

| Environment Variable       | Default               | Description                                                    | Sensitive | Required | In-line Var Equivalent |
| -------------------------- | --------------------- | -------------------------------------------------------------- | --------- | -------- | ---------------------- |
| TF_VAR_pm_api_token_id     | null                  | User's PVE API Token                                           | True      | Yes      | `pm_api_token_id`      |
| TF_VAR_pm_api_token_secret | null                  | UUID, a users token secret                                     | True      | Yes      | `pm_api_token_secret`  |
| TF_VAR_pm_api_url          | null                  | Proxmox API endpoint, e.g. 'https://pve.example.com/api2/json' | True      | Yes      | `pm_api_url`           |
| TF_VAR_ssh_key_public      | `.ssh/id_ed25519.pub` | Public SSH key file for VM host                                | True      | Yes      | `ssh_key_public`       |
| TF_VAR_dns_searchdomain    | null                  | Internal DNS server, e.g. 'dns.example.com' or '192.168.1.1'   | True      | Yes      | `dns_searchdomain`     |

Set Environment Variables. See 'Using a Secrets Management Tool' for examples using Bitwarden or HashiCorp Vault.

```bash
$ export TF_VAR_pm_api_token_id='MY_TOKEN_VALUE'
$ export TF_VAR_pm_api_token_secret='MY_SECRET_VALUE'
$ export TF_VAR_ssh_key_file=$(cat MY_SSH_KEY.pub)
$ export TF_VAR_pm_api_url=https://pve.example.com/api2/json
$ export TF_VAR_dns_searchdomain=dns.example.com

# create a terraform plan & apply it
$ terraform plan -out tfplan
$ terraform apply 'tfplan'
```

### Using In-line Variables

```sh
# create a terraform plan
$ terraform plan -var='pm_api_token_id=TOKEN' \
-var='pm_api_token_secret=SECRET' \
-var='pm_api_url=https://pve.example.com/api2/json' \
-var='dns_searchdomain=192.168.1.1' \
-out tfplan

# apply the plan
$ terraform apply 'tfplan'
```

## Using a Secrets Management Tool for Sensitive Variables

### Bitwarden

- This example assumes you have a bitwarden **item** named `terraform-proxmox` with the following entries: a **proxmox token** in the `username` field, **token secret** in the `password` field, and your **PVE api endpoint** in the first `website` field. Additionally, you can store the raw DNS value, e.g. `192.168.1.1` or `dns.example.com`, in the `note` field .

```sh
# login to bitwarden and export the session key
bw login
export BW_SESSION=$(bw unlock --raw)

# Set ENV Variables from Bitwarden Vault
export TF_VAR_pm_api_token_id=$(bw get username terraform-proxmox)
export TF_VAR_pm_api_token_secret=$(bw get password terraform-proxmox)
export TF_VAR_pm_api_url=$(bw get uri terraform-proxmox)
export TF_VAR_dns_searchdomain=$(bw get notes terraform-proxmox)

# create a terraform plan & apply it
terraform plan -out tfplan
terraform apply 'tfplan'
```

### HashiCorp Vault

```sh

```

## State Storage

- By default, Terraform stores state information in `terraform.tfstate` file in the local directory.
- This template **does not** define a backend for the state file. Thus, it will create a state file in the local directory. For additional information on securing state files and configuring different backends, e.g. `s3`, see:

  - [Terraform Developer - State]
  - [Terraform Developer - State Backends]
  - [Terraform Developer - Backend Configuration]

- The S3 backend works with local [minIO] buckets, for example:

```sh
terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "~> 2.9.0, < 2.9.13"
    }
  }
  backend "s3" {
    bucket   = "tf-bucket"
    key      = "terraform.tfstate"
    endpoint = "http://<MINIO-SERVER-IP>:9000"
    region   = "main"

    access_key = "MINIO_ACCESS_KEY"
    secret_key = "MINIO_SECRET_KEY"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}
```

## Proxmox API Token

### Minimal Permission Requirements

- Note the providers documentation suggest semi-broad permissions at the root path `/`, this template works with fewer permissions and only needs the following paths: `/storage`, `/vms`

```sh
# <=v2.9.11
Datastore.AllocateSpace Datastore.Audit VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.CPU VM.Config.Cloudinit VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Monitor VM.PowerMgmt
```

- As of `v2.9.13`

```sh
# Additional Requirements >=v2.9.13
Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Migrate
```

## License

MIT

## Author Information

Taylor Fore (https://github.com/trfore)

### Additional Templates & Tools

| Github Repo             | Description |
| ----------------------- | ----------- |
| [packer-proxmox]        |             |
| [proxmox-cloud-int]     |             |
| [terraform-proxmox-lxc] |             |
| [terraform-proxmox-vm]  |             |

# References

## Terraform

- [Terraform - Docs]
- [Terraform - Download]

## Terraform Provider - Proxmox

- [Telemate/Proxmox - Docs]
- [Telemate/Proxmox - Github]

## Terraform State File Management & Storage

- [Terraform Developer - State]
- [Terraform Developer - State Backends]
- [Terraform Developer - Backend Configuration]
- Storing Sensitive Values in State Files: https://github.com/hashicorp/terraform/issues/516#issuecomment-1525201716

## Secrets Management

- https://bitwarden.com/download/
- https://bitwarden.com/help/cli/
- https://github.com/bitwarden/clients
- https://www.vaultproject.io/
- https://developer.hashicorp.com/vault/docs

## Proxmox

- Proxmox VE API: https://pve.proxmox.com/wiki/Proxmox_VE_API
- Proxmox User Management: https://pve.proxmox.com/pve-docs/chapter-pveum.html

## Other

- [minIO]

[Terraform - Docs]: https://developer.hashicorp.com/terraform
[Terraform - Download]: https://developer.hashicorp.com/terraform/downloads?ajs_aid=77f69f10-ed45-4b9f-be17-f0f57095a395&product_intent=terraform
[Terraform Developer - State]: https://developer.hashicorp.com/terraform/language/state
[Terraform Developer - State Backends]: https://developer.hashicorp.com/terraform/language/state/backends
[Terraform Developer - Backend Configuration]: https://developer.hashicorp.com/terraform/language/settings/backends/configuration#available-backends
[Telemate/Proxmox - Docs]: https://registry.terraform.io/providers/Telmate/proxmox/latest/docs
[Telemate/Proxmox - Github]: https://github.com/Telmate/terraform-provider-proxmox
[packer-proxmox]: https://github.com/trfore/packer-proxmox
[proxmox-cloud-int]: https://github.com/trfore/proxmox-cloud-init
[terraform-proxmox-lxc]: https://github.com/trfore/terraform-proxmox-lxc
[terraform-proxmox-vm]: https://github.com/trfore/terraform-proxmox-vm
[minIO]: https://min.io/
