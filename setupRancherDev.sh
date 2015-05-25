#!/bin/bash

set -e
cd $(dirname $0)/

function blowUpAndDownloadCattle(){
    if [ -d "${CATTLE_ROOT}" ];then
        echo Deleting previous cattle
        rm -rf $CATTLE_ROOT
        git clone https://github.com/rancherio/cattle.git $CATTLE_ROOT
        echo Cattle Cloned From master into \$CATTLE_ROOT
        echo Your \$CATTLE_ROOT is set to $CATTLE_ROOT
        cp $CATTLE_ROOT/tools/eclipse/Cattle.launch $CATTLE_ROOT/code/packaging/app/
    else
        echo Cloning Cattle From master into $CATTLE_ROOT
        git clone https://github.com/rancherio/cattle.git $CATTLE_ROOT
        cp $CATTLE_ROOT/tools/eclipse/Cattle.launch $CATTLE_ROOT/code/packaging/app/
    fi
}

function getToolsToFarm(){
    if [ ! -z "${FARMERS_TOOLS}"];then
        if [ -d "${FARMERS_TOOLS}" ];then
            echo Deleting previous cattle
            rm -rf $FARMERS_TOOLS
            git clone https://github.com/rancherio/cattle.git $FARMERS_TOOLS
            echo Cattle Cloned From master into \$FARMERS_TOOLS
            echo Your \$FARMERS_TOOLS is set to $FARMERS_TOOLS
        else
            echo Cloning Cattle From master into $FARMERS_TOOLS
            git clone https://github.com/rancherio/cattle.git $FARMERS_TOOLS
            cd $FARMERS_TOOLS
            git pull
        fi
    else
        echo \$FARMERS_TOOLS not detected.
        echo please define this in your .profile.
        echo This is where your tools for the farm are.
        echo This is the tool repo https://github.com/rancherio/build-tools
}

if [ ! -z "${CATTLE_ROOT}" ];then
    xcode-select --install
    touch ~/.profile # If you don't have it
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew doctor
    brew tap caskroom/homebrew-cask
    brew install brew-cask
    brew cask install virtualbox
    brew install coreutils
    brew install maven
    brew install liquibase
    brew install gnu-sed --with-default-names
    brew install boot2docker
    brew install mysql
    boot2docker init
    boot2docker up
    $(boot2docker shellinit)
    # Now make docker go in all new shells
    docker run busybox # Prove it works!
    mysql.server start
    echo "Run mysql -uroot # if you want to test that mysql is running."
    sudo easy_install pip
    sudo pip install tox
    sudo pip install virtualenv

    # This will add stuff to .profile to ensure things work later.
    echo "export LIQUIBASE_HOME=$(find /usr/local/Cellar/liquibase -name libexec)" >> ~/.profile
    echo '$(boot2docker shellinit)' >> ~/.profile 
    echo "export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)" >> ~/.profile
    
    blowUpAndDownloadCattle
    getToolsToFarm
else
    echo \$CATTLE_ROOT not detected.
    echo please define this in your .profile or something sourced upon bash startup.
fi