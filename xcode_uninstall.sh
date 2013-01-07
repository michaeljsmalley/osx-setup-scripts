#!/bin/bash

info="[info]"
warning="[warning]"
error="[error]"
appdir="/Applications"

check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "$error This script must be run as root" 1>&2
        exit 1
    fi
}

uninstall_app() {
    [ ! -d $appdir/Xcode.app ] && echo -e "$info Nothing to remove. Exiting..." && exit 0

    echo -e "$info Xcode.app installed. Removing..."
    # Need to be at root
    cd /
    rm -rf $appdir/Xcode.app
    echo "$info Xcode.app has been removed."
}

# Make sure only root can run our script
check_root
# Uninstall Xcode.app
uninstall_app
