## GCP Cloud

### Usage
Apply terraform code
```
pushd terraform && terraform init && terraform apply && popd
```

Render bosh deployment
```
kite render manifest bosh --cloud=gcp
```

Setup tunnel
```
. bin/setup-tunnel.sh
```

Install BOSH
```
./bin/bosh-install.sh
```

Connect to the Director
```
. bin/set-env.sh

bosh alias-env bosh-1 -e 10.0.0.10 --ca-cert \
  <(bosh int ./config/creds.yml --path /director_ssl/ca)
```

Render concourse deployment
```
kite render manifest concourse --cloud=gcp
```

Install concourse
```
bosh -e bosh-1 update-cloud-config  deployments/concourse/cloud-config.yml

bosh -e bosh-1 upload-stemcell \
  https://bosh.io/d/stemcells/bosh-google-kvm-ubuntu-trusty-go_agent?v=3445.7

bosh -e bosh-1 upload-release \
  https://github.com/concourse/concourse/releases/download/v3.4.1/concourse-3.4.1.tgz

bosh -e bosh-1 upload-release \
  https://github.com/concourse/concourse/releases/download/v3.4.1/garden-runc-1.6.0.tgz

bosh -e bosh-1 -d concourse deploy deployments/concourse/concourse.yml
```
