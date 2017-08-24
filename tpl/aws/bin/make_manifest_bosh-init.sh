#!/bin/bash
#
#  Please set the following environment variables:
#  $AWS_ACCESS_KEY_ID
#  $AWS_SECRET_ACCESS_KEY
#  $AWS_REGION
#  $AWS_AZ
#  $BOSH_PASSWORD
#  $AWS_KEYPAIR_KEY_NAME
#  $PRIVATE_KEY_PATH

function getvars() {
  cd terraform/
  EIP=$(terraform output eip)
  SUBNET=$(terraform output default_subnet_id)
  SECURITY_GROUP=$(terraform output security_group_id)
  cd ../
}

getvars

echo "Subnet = $SUBNET"
echo "Security Group = $SECURITY_GROUP"
echo "EIP = $EIP"
echo "AWS REGION = $AWS_REGION"
echo "AWS AZ = $AWS_AZ"

cat >bosh-director.yml <<YAML
---
name: bosh

releases:
- name: bosh
  url: https://bosh.io/d/github.com/cloudfoundry/bosh?v=256.2
  sha1: ff2f4e16e02f66b31c595196052a809100cfd5a8
- name: bosh-aws-cpi
  url: https://bosh.io/d/github.com/cloudfoundry-incubator/bosh-aws-cpi-release?v=52
  sha1: dc4a0cca3b33dce291e4fbeb9e9948b6a7be3324

resource_pools:
- name: vms
  network: private
  stemcell:
    url: https://bosh.io/d/stemcells/bosh-aws-xen-hvm-ubuntu-trusty-go_agent?v=3232.3
    sha1: 1fe87c0146ad1f3b55eeed5a80ce35c01b4eb6d9
  cloud_properties:
    instance_type: m3.large
    ephemeral_disk: {size: 25_000, type: gp2}
    availability_zone: $AWS_AZ

disk_pools:
- name: disks
  disk_size: 20_000
  cloud_properties: {type: gp2}

networks:
- name: private
  type: manual
  subnets:
  - range: 10.0.0.0/24
    gateway: 10.0.0.1
    dns: [10.0.0.2]
    cloud_properties: {subnet: $SUBNET}
- name: public
  type: vip

jobs:
- name: bosh
  instances: 1

  templates:
  - {name: nats, release: bosh}
  - {name: postgres, release: bosh}
  - {name: blobstore, release: bosh}
  - {name: director, release: bosh}
  - {name: health_monitor, release: bosh}
  - {name: registry, release: bosh}
  - {name: aws_cpi, release: bosh-aws-cpi}

  resource_pool: vms
  persistent_disk_pool: disks

  networks:
  - name: private
    static_ips: [10.0.0.6]
    default: [dns, gateway]
  - name: public
    static_ips: [$EIP]

  properties:
    nats:
      address: 127.0.0.1
      user: nats
      password: $BOSH_PASSWORD

    postgres: &db
      listen_address: 127.0.0.1
      host: 127.0.0.1
      user: postgres
      password: $BOSH_PASSWORD
      database: bosh
      adapter: postgres

    registry:
      address: 10.0.0.6
      host: 10.0.0.6
      db: *db
      http: {user: admin, password: $BOSH_PASSWORD, port: 25777}
      username: admin
      password: $BOSH_PASSWORD
      port: 25777

    blobstore:
      address: 10.0.0.6
      port: 25250
      provider: dav
      director: {user: director, password: $BOSH_PASSWORD}
      agent: {user: agent, password: $BOSH_PASSWORD}

    director:
      address: 127.0.0.1
      name: eb-bosh
      db: *db
      cpi_job: aws_cpi
      max_threads: 10
      user_management:
        provider: local
        local:
          users:
          - {name: admin, password: $BOSH_PASSWORD}
          - {name: hm, password: $BOSH_PASSWORD}

    hm:
      director_account: {user: hm, password: $BOSH_PASSWORD}
      resurrector_enabled: true

    aws: &aws
      access_key_id: $AWS_ACCESS_KEY_ID
      secret_access_key: $AWS_SECRET_ACCESS_KEY
      default_key_name: $AWS_KEYPAIR_KEY_NAME
      default_security_groups: [$SECURITY_GROUP]
      region: $AWS_REGION

    agent: {mbus: "nats://nats:$BOSH_PASSWORD@10.0.0.6:4222"}

    ntp: &ntp [0.pool.ntp.org, 1.pool.ntp.org]

cloud_provider:
  template: {name: aws_cpi, release: bosh-aws-cpi}

  ssh_tunnel:
    host: $EIP # <--- Replace with your Elastic IP address
    port: 22
    user: vcap
    private_key: $PRIVATE_KEY_PATH # Path relative to this manifest file

  mbus: "https://mbus:$BOSH_PASSWORD@$EIP:6868" # <--- Replace with Elastic IP

  properties:
    aws: *aws
    agent: {mbus: "https://mbus:$BOSH_PASSWORD@0.0.0.0:6868"}
    blobstore: {provider: local, path: /var/vcap/micro_bosh/data/cache}
    ntp: *ntp
YAML
