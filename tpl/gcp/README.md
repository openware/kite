## GCP Cloud

### Usage
Apply terraform code
```
pushd terraform && terraform init && terraform apply && popd
```

Render bosh deployment
```
kite render bosh --cloud=gcp
```

Setup tunnel
```
./bin/setup-tunnel.sh
```

Install BOSH
```
./bin/bosh-install.sh
```
