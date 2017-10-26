## AWS Cloud

### Setup

Apply terraform code
```
pushd terraform && terraform init && terraform apply && popd
```

[Note]
To destroy Bastion later, use `terraform destroy -target aws_instance.bastion`

Render BOSH manifest and related files
```
kite render manifest bosh --cloud aws
```

Prepare BOSH environment using instructions from [docs/bosh.md](docs/bosh.md)

[Optional]
If you want to access components outside of your VPC, use the Ingress deployment:

Render Ingress deployment files
```
kite render manifest prometheus --cloud aws
```

Follow instructions from [docs/prometheus.md](docs/prometheus.md) to deploy Prometheus

[Note]
If you're using Ingress, create CNAME DNS records for each deployment as listed in `config/cloud.yml`(e.g. vault.example.com pointing to ingress.example.com)

Render Prometheus deployment files
```
kite render manifest prometheus --cloud aws
```

Follow instructions from [docs/prometheus.md](docs/prometheus.md) to deploy Prometheus

Render Vault deployment
```
kite render manifest vault --cloud aws
```

Follow instructions from [docs/vault.md](docs/vault.md) to deploy Vault

Render Concourse manifest
```
kite render manifest concourse --cloud aws
```

Follow instructions from [docs/concourse.md](docs/concourse.md) to deploy Concourse
