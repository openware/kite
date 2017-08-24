#!/bin/bash

bosh delete deployment concourse

cd ~/google-bosh-director
bosh-init delete manifest.yml
