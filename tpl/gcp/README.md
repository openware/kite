# GCP Cloud

## Setup

### Prerequisites
Set path to your service account credentials:
```
export GOOGLE_CREDENTIALS=*~/credentials/service-account.json*
```

### Setup the basic infrastructure and bastion
Apply terraform code
```
pushd terraform && terraform init && terraform apply && popd
```

[Note]
To destroy Bastion later, use `terraform destroy -target google_compute_instance.bastion`

### Setup BOSH
Render BOSH manifest and related files
```
kite render manifest bosh --cloud gcp
```

Prepare BOSH environment using instructions from [docs/bosh.md](docs/bosh.md)

### Setup INGRESS
Render Ingress manifest and related files
```
kite render manifest ingress --cloud gcp
```

Follow instructions from [docs/ingress.md](docs/ingress.md) to deploy Ingress


### Setup VAULT
Render Vault deployment
```
kite render manifest vault --cloud gcp
```

Follow instructions from [docs/vault.md](docs/vault.md) to deploy Vault

### Setup CONCOURSE
[Note]
To expose concourse publicly, you must create first (manually) a virtual IP in GCP and create a DNS A entry for the hostname for this IP. Set the IP into config/cloud.yml (concourse.vip).

Render Concourse manifest
```
kite render manifest concourse --cloud gcp
```

Follow instructions from [docs/concourse.md](docs/concourse.md) to deploy Concourse
