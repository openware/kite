#!/usr/bin/env bash

set -xe

# Apply Terraform IaC
pushd terraform

terraform init
terraform apply

popd

# Set up an SSH tunnel to Bastion
. bin/setup-tunnel.sh

# Render BOSH manifest and related files
kite render manifest bosh --cloud aws

# Deploy BOSH Director
./bin/bosh-install.sh

# Set the needed environment variables
. bin/set-env.sh

# Render Vault manifest
kite render manifest vault --cloud aws

# Deploy Vault
./bin/vault-deploy.sh

# Render Concourse manifest and related files
kite render manifest concourse --cloud aws

# Deploy Concourse
./bin/concourse-deploy.sh
