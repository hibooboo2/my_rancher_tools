#!/bin/bash

set -e

CMDS="hub jq curl git"

for i in $CMDS
do
        # command -v will return >0 when the $i is not found
	which $i >/dev/null && continue || { echo "$i command not found."; exit 1; }
done
if [ -d ${RANCH_HOME:?"Is is not set. Please set it."} ]; then
    cd ${RANCH_HOME}
    for i in $(curl -# https://api.github.com/orgs/rancherio/repos | jq -r .[].name)
    do 
        if [ ! -d "${RANCH_HOME}/$i" ]; then
            if [ "$1" == "pull" ]; then
                cd ${RANCH_HOME}
                hub clone rancherio/$i >/dev/null && echo Cloned $i
            fi
        else
            echo You already have rancherio/$i
            if [ "$1" == "update" ]; then
                echo ${RANCH_HOME}/$i
                cd ${RANCH_HOME}/$i
                git fetch --all
            fi
        fi
    done
fi
