function fixTheRanch(){
    moo
    mysql.server start
    mysql -uroot < resources/content/db/mysql/create_db_and_user_dev.sql > /dev/null
    $CATTLE_ROOT/resources/content/db/mysql/drop_tables.sh
    boot2docker up
    moo
    ./tools/development/register-boot2docker.sh
}

function setupTheRanch(){
    moo
    mysql.server start
    $CATTLE_ROOT/resources/content/db/mysql/drop_tables.sh
    rm -f $CATTLE_ROOT/code/packaging/app/Cattle.launch
    cp $CATTLE_ROOT/tools/eclipse/Cattle.launch $CATTLE_ROOT/code/packaging/app/
    rancherAgent
    cd $CATTLE_ROOT/tests/integration
    rm -rf .venv
    virtualenv .venv
    . .venv/bin/activate
    pip install -r test-requirements.txt
    pip install -r requirements.txt
    pip install tox
}


function testRanchSpy(){
    cd $SPY_HOME
    if [ ! -d ".venv" ];then
        mkdir .venv && virtualenv .venv && . .venv/bin/activate
    else
        . ./.venv/bin/activate
    fi
    pip install -r requirements.txt 1> /dev/null
    pip install -r test-requirements.txt 1> /dev/null
    pip install -r dist-requirements.txt 1> /dev/null
    mkdir $HOME/cattle-home
    CATTLE_DOCKER_USE_BOOT2DOCKER=true CATTLE_HOME=$HOME/cattle-home \
    py.test tests
}
