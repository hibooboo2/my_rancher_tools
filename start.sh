#!/bin/bash
echo Hello
export PATH="${PATH}:/source/bin/"
export RANCH_HOME="/source/code/"
git config --global hub.protocol https

cd /source/
mkdir code
