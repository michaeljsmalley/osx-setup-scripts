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

unsupported_osxversion() {
    echo "$error This machine is running an unsupported version of OS X"
    exit 1
}

detect_osx_version() {
    result=`sw_vers -productVersion`

    if [[ $result =~ "10.7" ]]; then
        osxversion="10.7"
        osxvername="Lion"
        dmg=xcode4520418508a.dmg
        mountpath="/Volumes/Xcode"
        mpkg="Xcode.mpkg"
    elif [[ $result =~ "10.8" ]]; then
        osxversion="10.8"
        osxvername="Mountain Lion"
        dmg=xcode4520418508a.dmg
        mountpath="/Volumes/Xcode"
        mpkg="Xcode.mpkg"
    else
        unsupported_osxversion
    fi

    echo -e "$info Detected OS X $osxversion $osxvername"
}

check_tools() {
    RECEIPT_FILE=/var/db/receipts/com.apple.pkg.XcodeMAS_iOSSDK_6_0.bom

    if [ -f "$RECEIPT_FILE" ]; then
        echo -e "$info Xcode is already installed. Exiting..."
        exit 1
    fi
}

download_tools () {
    # Use curl to download the appropriate installer to tmp
    if [ ! -f /tmp/$dmg ]; then
        echo -e "$info Downloading Xcode for Mac OS X $osxversion"
        cd /tmp && curl -O $webserver/$dmg
    else
        echo -e "$info $dmg already downloaded to /tmp/$dmg."
    fi
}

install_tools() {
    # Mount the Command Line Tools dmg
    echo -e "$info Mounting Xcode..."
    hdiutil mount /tmp/$dmg
    # Run the Command Line Tools Installer
    echo -e "$info Installing Xcode..."
    cp -R /Volumes/Xcode/Xcode.app /Applications/Xcode.app
    # Unmount the Command Line Tools dmg
    echo -e "$info Unmounting XCode..."
    hdiutil unmount "$mountpath"
}

cleanup () {
    #rm /tmp/$dmg
    echo "$info Cleanup complete."
    exit 0
}

# Make sure only root can run our script
check_root
# Detect and set the version of OS X for the rest of the script
detect_osx_version
# Check for if tools are already installed by looking for a receipt file
check_tools
# Check for and if necessary download the required dmg
download_tools
# Start the appropriate installer for the correct version of OSX
install_tools
# Cleanup files used during script
cleanup
