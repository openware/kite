#!/bin/bash

zone=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/zone)
export zone=${zone##*/}
export region=${zone%-*}
gcloud config set compute/zone ${zone}
gcloud config set compute/region ${region}
export project_id=`curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/project/project-id`

export ssh_key_path=$HOME/.ssh/bosh

bosh upload stemcell https://bosh.io/d/stemcells/bosh-google-kvm-ubuntu-trusty-go_agent?v=3263.8

bosh upload release https://bosh.io/d/github.com/concourse/concourse?v=2.5.0
bosh upload release https://bosh.io/d/github.com/cloudfoundry/garden-runc-release?v=1.0.3

export external_ip=`gcloud compute addresses describe concourse | grep ^address: | cut -f2 -d' '`
export director_uuid=`bosh status --uuid 2>/dev/null`

openssl rand -base64 16 > ~/common_password
cp ~/common_password ~/atc_password

export common_password=$(cat ~/common_password)
export atc_password=$(cat ~/atc_password)

bosh update cloud-config ~/gcp/cloud-config.yml

bosh deployment ~/gcp/concourse.yml
bosh deploy
