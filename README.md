# Plan a Deployment

## Setting Environmental Vars

1. Create Env Vars via CLI

```bash
$ export TF_VAR_ssh_key_file=$(cat SSH_KEY.pub)
$ export TF_VAR_pm_api_url=https://pve.example.com/api2/json
$ export TF_VAR_DNS_searchdomain=dns.example.com
$ export PM_API_TOKEN_ID='TOKEN'
$ export PM_API_TOKEN_SECRET='SECRET'
```

2. Plan and Apply

```bash
$ terraform plan -out tfplan
$ terraform apply 'tfplan'
```

## In-line Vars

```bash
# create a terraform plan
$ terraform plan -var='pm_api_token_id=TOKEN' \
-var='pm_api_token_secret=SECRET' \
-var='pm_api_url=https://pve.example.com/api2/json' \
-var='DNS_searchdomain=192.168.1.1' \
-out tfplan
```

## Using a Secrets Management Tool

### Bitwarden

```bash

```
