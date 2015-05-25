#!/bin/bash
cd ${CATTLE_ROOT:= "${HOME}/code/rancherio/cattle"}
export CATTLE_TEST_HTTP_PORT=8086
export CATTLE_URL="http://localhost:${CATTLE_TEST_HTTP_PORT}/v1/schemas"
./scripts/build >> /dev/null
./scripts/run --background >> /dev/null
. ./.venv/bin/activate
python -m pytest ${CATTLE_ROOT}/tests/integration/cattletest/core/${CATTLE_TEST_TO_RUN}
TEST_EXIT="$?"
ps -ef | grep war | grep run-success | cut -f 4 -d " " |xargs kill
deactivate
exit $TEST_EXIT
