#!/bin/bash

# Include configuration values from config.sh
source config

info="[info]"
warning="[warning]"
error="[error]"
appdir="/Applications"
dmg=xcode4520418508a.dmg
mountpath="/Volumes/Xcode"
mpkg="Xcode.mpkg"

check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "$error This script must be run as root" 1>&2
        exit 1
    fi
}

check_app() {
    [ -d $appdir/Xcode.app ] && echo -e "$info Xcode is already installed. Exiting..." && exit 0
}

download_app() {
    # Use curl to download the appropriate installer to tmp
    if [ ! -f /tmp/$dmg ]; then
        echo -e "$info Downloading Xcode for Mac OS X"
        cd /tmp && curl -O $webserver/$dmg
    else
        echo -e "$info $dmg already downloaded to /tmp/$dmg."
    fi
}

install_app() {
    # Mount the Xcode dmg
    echo -e "$info Mounting Xcode..."
    hdiutil mount /tmp/$dmg
    # Copy the Xcode app to /Applications
    echo -e "$info Installing Xcode..."
    cp -R $mountpath/Xcode.app $appdir/Xcode.app
    # Unmount the Xcode dmg
    echo -e "$info Unmounting Xcode..."
    hdiutil unmount "$mountpath"
}

cleanup () {
    #rm /tmp/$dmg
    echo "$info Cleanup complete."
    exit 0
}

# Make sure only root can run our script
check_root
# Check to see if Xcode is already installed
check_app
# Check for and if necessary download the required dmg
download_app
# Install Xcode
install_app
# Cleanup files used during script
cleanup
