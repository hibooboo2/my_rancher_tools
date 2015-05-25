#!/bin/bash

set -e

cd $(dirname $0)/
./safteyChecks.sh

echo Stopped
cd $CATTLE_ROOT
git fetch --all