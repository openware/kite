BOSH Director & Concourse Bootstrap
===================================

This project achieves the following:

- Preparation of an AWS environment for BOSH & Concourse
- Deployment of a new BOSH Director using bosh-init
- Deployment of a new Concourse cluster, or standalone server

Terraform is used to setup the base network and security infrastructure, including an ELB for Concourse.

Requirements
-----

- Install [terraform](https://www.terraform.io/intro/getting-started/install.html)
- Install [bosh](https://bosh.io/docs/cli-v2.html#install)

Usage
-----

To bootstrap the whole deployment just run `bootstrap.sh`

To access BOSH Director information, use bosh -e *bosh_name* env

To connect to Bastion over SSH, use ssh jumpbox@*bastion ip* -i jumpbox.key
