#!/bin/bash

# Accessible webserver containing Command Line Tools dmg
webserver="http://yourserver/software/"

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
        cltools=xcode452cltools10_76938212a.dmg
        mountpath="/Volumes/Command Line Tools (Lion)"
        mpkg="Command Line Tools (Lion).mpkg"
    elif [[ $result =~ "10.8" ]]; then
        osxversion="10.8"
        osxvername="Mountain Lion"
        cltools=xcode452cltools10_86938211a.dmg
        mountpath="/Volumes/Command Line Tools (Mountain Lion)"
        mpkg="Command Line Tools (Mountain Lion).mpkg"
    else
        unsupported_osxversion
    fi

    echo -e "$info Detected OS X $osxversion $osxvername"
}

check_tools() {
    RECEIPT_FILE=/var/db/receipts/com.apple.pkg.DeveloperToolsCLI.bom

    if [ -f "$RECEIPT_FILE" ]; then
        echo -e "$info Command Line Tools are already installed. Exiting..."
        exit 1
    fi
}

download_tools () {
    # Use curl to download the appropriate installer to tmp
    if [ ! -f /tmp/$cltools ]; then
        echo -e "$info Downloading Command Line Tools for Mac OS X $osxversion"
        cd /tmp && curl -O $webserver/$cltools
    else
        echo -e "$info $cltools already downloaded to /tmp/$cltools."
    fi
}

install_tools() {
    # Mount the Command Line Tools dmg
    echo -e "$info Mounting Command Line Tools..."
    hdiutil mount /tmp/$cltools
    # Run the Command Line Tools Installer
    echo -e "$info Installing Command Line Tools..."
    #installer -pkg "/Volumes/Command Line Tools (Lion)/Command Line Tools (Lion).mpkg" -target "/Volumes/Macintosh HD"
    installer -pkg "$mountpath/$mpkg" -target "/Volumes/Macintosh HD"
    # Unmount the Command Line Tools dmg
    echo -e "$info Unmounting Command Line Tools..."
    hdiutil unmount "$mountpath"
}

cleanup () {
    #rm /tmp/$cltools
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
