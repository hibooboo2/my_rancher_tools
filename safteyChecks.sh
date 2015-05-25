#!/bin/bash

set -e
cd $(dirname $0)/
[[ ! -f "./.rancherProfile" ]] && echo No rancherProfile Please create one && exit 1
echo You are configured
