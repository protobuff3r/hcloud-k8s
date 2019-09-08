# Install Infrastructure on HCloud

1. Create a HCloud Project in Hetzner Cloud Console
2. Create a API Token and set in terraform/variables.tf and ansible/env/values.yaml
3. Add your public ssh-keys in terraform/user-data/cloud-config.yaml "ssh_authorized_keys"

```bash
terraform init
terraform apply
terraform output -json > outputs.json
```