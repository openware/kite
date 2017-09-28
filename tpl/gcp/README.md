## GCP Cloud

### Setup

Set path to your service account credentials:
```
export GOOGLE_CREDENTIALS=*~/credentials/service-account.json*
```

Apply terraform code
```
pushd terraform && terraform init && terraform apply && popd
```

Render BOSH manifest and related files
```
kite render manifest bosh --cloud gcp
```

Prepare BOSH environment using instructions from [docs/bosh.md](docs/bosh.md)

Render Vault deployment
```
kite render manifest vault --cloud gcp
```

Follow instructions from [docs/vault.md](docs/vault.md) to deploy Vault

Render Concourse manifest
```
kite render manifest concourse --cloud gcp
```

Follow instructions from [docs/concourse.md](docs/concourse.md) to deploy Concourse
