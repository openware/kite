export projectid=helios-devel
export region=europe-west1
export zone=europe-west1-b
export service_account_email=terraform-bosh@${projectid}.iam.gserviceaccount.com

export GOOGLE_CREDENTIALS=$(cat /tmp/terraform-bosh.key.json)

docker run -i -t \
  -e "GOOGLE_CREDENTIALS=${GOOGLE_CREDENTIALS}" \
  -v `pwd`:/$(basename `pwd`) \
  -w /$(basename `pwd`) \
  hashicorp/terraform:light destroy \
    -var service_account_email=${service_account_email} \
    -var projectid=${projectid} \
    -var region=${region} \
    -var zone-1=${zone}

gcloud projects remove-iam-policy-binding ${projectid} \
        --member serviceAccount:${service_account_email} \
        --role roles/owner

gcloud iam service-accounts delete ${service_account_email}
rm /tmp/terraform-bosh.key.json
