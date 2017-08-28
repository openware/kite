#!/usr/bin/env bash


pushd terraform && terraform apply && popd

kite render-manifest --manifest=bosh
bosh-init deploy bosh-director.yml

pushd terraform && BOSH_DIRECTOR_IP=$(terraform output eip) && popd
bosh target $BOSH_DIRECTOR_IP

kite render-manifest --manifest=concourse
bosh update cloud-config aws-cloud.yml

bosh upload stemcell https://bosh.io/d/stemcells/bosh-aws-xen-hvm-ubuntu-trusty-go_agent
bosh upload release https://bosh.io/d/github.com/concourse/concourse
bosh upload release https://bosh.io/d/github.com/cloudfoundry-incubator/garden-runc-release

bosh deployment concourse.yml

bosh deploy
