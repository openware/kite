#!/bin/bash

source .env

if ! gcloud auth list | grep @heliostech.fr; then
    gcloud auth login
fi

gcloud config set project ${projectid}
gcloud config set compute/zone ${zone}
gcloud config set compute/region ${region}

source scripts/01_create_infrastructure.sh

# ${bastion_vm_name} ssh timeout
sleep 10

gcloud compute scp --scp-flag=-r . ${bastion_vm_name}:$HOME/gcp

gcloud compute ssh ${bastion_vm_name} -- source gcp/scripts/02_deploy_director.sh

gcloud compute ssh ${bastion_vm_name} -- source gcp/scripts/03_deploy_concourse.sh
