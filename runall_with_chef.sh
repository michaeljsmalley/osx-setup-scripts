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

runall() {
    /bin/bash cltools_install.sh
    /bin/bash xcode_install.sh
    /usr/bin/curl -L https://opscode.com/chef/install.sh | sudo /bin/bash
}

cleanup () {
    #rm /tmp/$dmg
    echo "$info runall Complete!"
    exit 0
}

# Make sure only root can run our script
check_root
# Run all installers!
runall
# Cleanup files used during script
cleanup
