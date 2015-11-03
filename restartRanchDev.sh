#! /bin/bash

set -ex

cd $(dirname $0)/
./safteyChecks.sh

mysql.server start 1> /dev/null

mysql -uroot < ./delDatabase.sql 1> /dev/null
cd ${CATTLE_ROOT:=${HOME}/code/rancher/cattle}
mysql -uroot < ./resources/content/db/mysql/create_db_and_user_dev.sql 1> /dev/null
echo Restarted
