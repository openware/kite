#!/bin/bash

cd "$(dirname "$0")"

if [ ! -d "workspace" ]; then
  mkdir "workspace"
  echo -e "KITE_CLOUDS_LOCAL_PATH=$PWD/workspace\n" >./.env
fi

if [ ! "$(docker ps -a | grep mykitehelper)" ]; then
  docker-compose run --name mykitehelper -w /root kitehelper /root/create_new_cloud.sh
else
  docker start -ai mykitehelper
fi
