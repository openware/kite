#!/bin/bash

if [ ! -f /tmp/terraform-bosh.key.json ]; then
    gcloud iam service-accounts create terraform-bosh

    gcloud iam service-accounts keys create /tmp/terraform-bosh.key.json \
        --iam-account ${service_account_email}

    gcloud projects add-iam-policy-binding ${projectid} \
        --member serviceAccount:${service_account_email} \
        --role roles/owner
fi

export GOOGLE_CREDENTIALS=$(cat /tmp/terraform-bosh.key.json)

docker run -i -t \
  -e "GOOGLE_CREDENTIALS=${GOOGLE_CREDENTIALS}" \
  -v `pwd`:/$(basename `pwd`) \
  -w /$(basename `pwd`) \
  hashicorp/terraform:light apply \
    -var service_account_email=${service_account_email} \
    -var projectid=${projectid} \
    -var region=${region} \
    -var zone-1=${zone}
