#!/bin/bash
#
#  Please set the following environment variables:
#  $AWS_AZ


function getvars() {
  cd terraform/
  DEFAULT_SUBNET=$(terraform output default_subnet_id)
  OPS_SUBNET=$(terraform output ops_services_subnet_id)
  cd ../
}

getvars

echo "Default Subnet = $DEFAULT_SUBNET"
echo "Ops Services Subnet = $OPS_SUBNET"
echo "AWS AZ" = $AWS_AZ


cat >aws-cloud.yml <<YAML
---
azs:
- name: z1
  cloud_properties: {availability_zone: $AWS_AZ}

vm_types:
- name: concourse_standalone
  cloud_properties:
    instance_type: m3.large
    ephemeral_disk: {size: 5000, type: gp2}
    elbs: [concourse-elb]
    security_groups: [concourse-sg, boshdefault]
- name: concourse_web
  cloud_properties:
    instance_type: m3.medium
    ephemeral_disk: {size: 3000, type: gp2}
    elbs: [concourse-elb]
    security_groups: [concourse-sg, boshdefault]
- name: concourse_db
  cloud_properties:
    instance_type: m3.medium
    ephemeral_disk: {size: 3000, type: gp2}
    security_groups: [boshdefault]
- name: concourse_worker
  cloud_properties:
    instance_type: m3.large
    ephemeral_disk: {size: 30000, type: gp2}
    security_groups: [boshdefault]
- name: default
  cloud_properties:
    instance_type: t2.micro
    ephemeral_disk: {size: 3000, type: gp2}
    security_groups: [boshdefault]
- name: large
  cloud_properties:
    instance_type: m3.large
    ephemeral_disk: {size: 5000, type: gp2}
    security_groups: [boshdefault]
- name: vault-default
  cloud_properties:
    instance_type: t2.micro
    ephemeral_disk: {size: 3000, type: gp2}
    security_groups: [vault-sg, boshdefault]

disk_types:
- name: default
  disk_size: 3000
  cloud_properties: {type: gp2}
- name: large
  disk_size: 50_000
  cloud_properties: {type: gp2}

networks:
- name: default
  type: manual
  subnets:
  - range: 10.0.0.0/24
    gateway: 10.0.0.1
    az: z1
    static: [10.0.0.6]
    reserved: [10.0.0.1-10.0.0.5]
    dns: [10.0.0.2]
    cloud_properties: {subnet: $DEFAULT_SUBNET}
- name: ops_services
  type: manual
  subnets:
  - range: 10.0.10.0/24
    gateway: 10.0.10.1
    az: z1
    reserved: [10.0.10.1-10.0.10.5]
    dns: [10.0.0.2]
    cloud_properties: {subnet: $OPS_SUBNET}
- name: vip
  type: vip

compilation:
  workers: 5
  reuse_compilation_vms: true
  az: z1
  vm_type: large
  network: default

YAML
