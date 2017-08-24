#!/bin/bash

source .env

if ! gcloud auth list | grep @heliostech.fr; then
    gcloud auth login
    gcloud config set project ${projectid}
    gcloud config set compute/zone ${zone}
    gcloud config set compute/region ${region}
fi

gcloud compute scp --scp-flag=-r . ${bastion_vm_name}:$HOME/gcp

gcloud compute ssh ${bastion_vm_name} -- source gcp/scripts/04_delete_director.sh

source scripts/05_delete_infrastructure.sh
