#!/bin/bash

zone=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/zone)
export zone=${zone##*/}
export region=${zone%-*}
gcloud config set compute/zone ${zone}
gcloud config set compute/region ${region}
export project_id=`curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/project/project-id`

if [ ! -f ~/.ssh/bosh  ]; then
    ssh-keygen -t rsa -f ~/.ssh/bosh -C bosh

    echo "------------------~/.ssh/bosh.pub------------------"
    cat ~/.ssh/bosh.pub
    echo "---------------------------------------------------"

    echo "Navigate to your project's web console and add the new SSH public key by pasting the contents of ~/.ssh/bosh.pub:"
    read -p "Press [Enter] to continue..."
fi

export ssh_key_path=$HOME/.ssh/bosh

while ! bosh-init -v; do
   echo "bosh-init is not ready yet..."
   sleep 5
done

mkdir google-bosh-director
cd google-bosh-director

cp ~/gcp/manifest.yml manifest.yml

bosh-init deploy manifest.yml

bosh target 10.0.0.6
