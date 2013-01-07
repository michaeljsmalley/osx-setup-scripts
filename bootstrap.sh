#!/bin/bash

# Include configuration values from config.sh
source config

info="[info]"
warning="[warning]"
error="[error]"

check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "$error This script must be run as root" 1>&2
        exit 1
    fi
}

bootstrap() {
    /bin/bash cltools_install.sh
    /bin/bash xcode_install.sh
}

cleanup () {
    #rm /tmp/$dmg
    echo "$info Bootstrap Complete!"
    exit 0
}

# Make sure only root can run our script
check_root
# Bootstrap!
bootstrap
# Cleanup files used during script
cleanup
