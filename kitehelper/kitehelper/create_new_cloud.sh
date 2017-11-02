#!/bin/bash

[ -d "/root/workspace/ssh" ] || mkdir "workspace/ssh"
if [ ! -f "/root/workspace/ssh/kite.key" ]; then
  ssh-keygen -t rsa -f "/root/workspace/ssh/kite.key" -N ''
fi

cp /root/workspace/ssh/* /root/.ssh

[ -d "/root/workspace/bosh_concourse_cloud" ] || kite new /root/workspace/bosh_concourse_cloud

cd /root/workspace/

/bin/bash
