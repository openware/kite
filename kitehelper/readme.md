# Setup Concourse CI with Bosh on AWS and Google by using Kite

This containerized version of Kite will assist you to deploy Concourse CI on cloud platforms.

Kite is a CLI tool for scaffolding and managing devops modules. The main purpose is additional templating of various tools like Terraform and Bosh.

For more information see https://github.com/helios-technologies/kite

## Usage

1. Build and execute container by calling run.sh. You can call run.sh every time you want to access the container
2. Edit workspace/bosh_concourse_cloud/config/cloud.yml
	- aws -> access_key and secret_key from AWS IAM User
	- bosh -> password (choose one)
	- bosh -> keypair name (with this name keypair will be added at aws)
	- bosh -> key settings: don't change this (change it in .env file)
	- bosh -> db_password (choose one)
	- concourse -> hostname will be created but domain must exist as zone in route 53
	- concourse -> dns_zone: zone id of the given domain
	- concourse -> choose auth credentials and db_password
3. mykitehelper$ cd /root/workspace/bosh_concourse_cloud/
4. mykitehelper$ kite generate --cloud=aws
5. mykitehelper$ cd terraform/
6. mykitehelper$ terraform init
7. mykitehelper$ terraform plan
8. mykitehelper$ terraform apply
9. mykitehelper$ cd ..
10. mykitehelper$ source bin/setup-tunnel.sh
11. mykitehelper$ kite render manifest bosh --cloud=aws
12. mykitehelper$ bin/bosh-install.sh
13. (test with: mykitehelper$ bosh -e bosh-director env)
14. mykitehelper$ source ./bin/set-env.sh
15. (mykitehelper$ bosh -e bosh-director ur https://bosh.io/d/github.com/cloudfoundry/garden-runc-release )
16. mykitehelper$ bin/concourse-deploy.sh

## Tear down everything

1. Start container again via run.sh
2. mykitehelper$ bosh -e bosh-director delete-deployment -d concourse
3. mykitehelper$ bosh delete-env deployments/bosh/bosh.yml \
  --state=config/state.json \
  --vars-store=config/creds.yml \
  --vars-file=deployments/bosh/bosh_vars.yml \
  --var-file private_key=~/.ssh/kite.key \
  -o deployments/bosh/cpi.yml \
  -o deployments/bosh/jumpbox-user.yml
4. mykitehelper$ cd terraform/
5. mykitehelper$ terraform destroy

## Visualice AWS setup

1. Start container again via run.sh
2. mykitehelper$ cd /root/workspace/bosh_concourse_cloud/terraform
3. mykitehelper$ terraform graph | dot -Tpng > /root/workspace/graph.png

## Update kite (from git repo)

1. Destroy docker container and image (docker rm & docker rmi)
2. Execute run.sh
