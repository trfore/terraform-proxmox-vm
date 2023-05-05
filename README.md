# Create Proxmox VM using Terraform

## Plan a Deployment

1. Install Terraform (link: [Terraform - Download])
2. Clone this repo and `cd` into the directory
3. Configure the `terraform.tfvars` file, a template is provided.
4. Initialize the Terraform Proxmox provider `terraform init`
5. Set variables using: ENV vars or CLI in-line args.
6. Run `terraform plan -out tfplan`, see 'In-line Vars' section for a complete example using `-var` flag.
7. Run `terraform apply 'tfplan'`

### Setting Environment Variables

| Environment Variable          | Default               | Description                                                    | Required | In-line Variable Equivalent |
| ----------------------------- | --------------------- | -------------------------------------------------------------- | -------- | --------------------------- |
| PM_API_TOKEN_ID               | null                  |                                                                | Yes      | `pm_api_token_id`           |
| PM_API_TOKEN_SECRET           | null                  |                                                                | Yes      | `pm_api_token_secret`       |
| TF_VAR_ssh_key_public         | `.ssh/id_ed25519.pub` | Public SSH Key for VM Host                                     | Yes      | `ssh_key_public`            |
| TF_VAR_ssh_key_public_ansible | `.ssh/id_ed25519.pub` | Ansible Public SSH Key for VM Host                             | No       | `ssh_key_public_ansible`    |
| TF_VAR_pm_api_url             | null                  | Proxmox API Endpoint, e.g. 'https://pve.example.com/api2/json' | Yes      | `pm_api_url`                |
| TF_VAR_DNS_searchdomain       | null                  |                                                                | Yes      | `dns_searchdomain`          |

1. Set ENV vars

```bash
# Individually
$ export PM_API_TOKEN_ID='TOKEN'
$ export PM_API_TOKEN_SECRET='SECRET'
$ export TF_VAR_ssh_key_file=$(cat SSH_KEY.pub)
$ export TF_VAR_pm_api_url=https://pve.example.com/api2/json
$ export TF_VAR_DNS_searchdomain=dns.example.com
# Or single line
export PM_API_TOKEN_ID='TOKEN' [...] TF_VAR_DNS_searchdomain='dns.example.com'
```

2. Plan and Apply

```sh
# create a terraform plan & apply it
$ terraform plan -out tfplan
$ terraform apply 'tfplan'
```

### Using In-line Vars (Recommended)

```sh
# create a terraform plan
$ terraform plan -var='pm_api_token_id=TOKEN' \
-var='pm_api_token_secret=SECRET' \
-var='pm_api_url=https://pve.example.com/api2/json' \
-var='DNS_searchdomain=192.168.1.1' \
-out tfplan

# apply the plan
$ terraform apply 'tfplan'
```

## Using a Secrets Management Tool for Secrets

### Bitwarden

```sh

```

### HCL Vault

```sh

```

## License

MIT

## Author Information

Taylor Fore (https://github.com/trfore)

# References

## Terraform

- [Terraform - Docs]
- [Terraform - Download]

## Proxmox Provider

- https://registry.terraform.io/providers/Telmate/proxmox/latest/docs
- https://github.com/Telmate/terraform-provider-proxmox

[Terraform - Docs]: https://developer.hashicorp.com/terraform
[Terraform - Download]: https://developer.hashicorp.com/terraform/downloads?ajs_aid=77f69f10-ed45-4b9f-be17-f0f57095a395&product_intent=terraform
