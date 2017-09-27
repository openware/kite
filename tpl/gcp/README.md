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


## Extends kite for your needs

You can extend kite with you own commands.

Create a specific command _hello_ with sub-commands _world_ and _kitty_ for your project:

```
kite generate task hello world kitty
```
