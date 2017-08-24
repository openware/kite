#!/usr/bin/env bash

source ./.env

pushd terraform && terraform apply && popd

bash ./bin/make_manifest_bosh-init.sh
bosh-init deploy bosh-director.yml

read -p "Enter bosh director ip: " bosh_director_ip
pushd terraform && BOSH_DIRECTOR_IP=$(terraform output eip) && popd
bosh target $BOSH_DIRECTOR_IP

bash ./bin/make_cloud_config.sh
bosh update cloud-config aws-cloud.yml

bosh upload stemcell https://bosh.io/d/stemcells/bosh-aws-xen-hvm-ubuntu-trusty-go_agent
bosh upload release https://bosh.io/d/github.com/concourse/concourse
bosh upload release https://bosh.io/d/github.com/cloudfoundry-incubator/garden-runc-release

bash ./bin/make_manifest_concourse-cluster.sh
bosh deployment concourse.yml

bosh deploy
