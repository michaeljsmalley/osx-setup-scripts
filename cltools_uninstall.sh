#!/bin/bash

info="[info]"
warning="[warning]"
error="[error]"

check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "$error This script must be run as root" 1>&2
        exit 1
    fi
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
        echo "$error This machine is running an unsupported version of OS X"
        exit 1
    fi

    echo -e "$info Detected OS X $osxversion $osxvername"
}


uninstall_tools() {
    RECEIPT_FILES=("/var/db/receipts/com.apple.pkg.DeveloperToolsCLI.bom")
    RECEIPT_PLISTS=("/var/db/receipts/com.apple.pkg.DeveloperToolsCLI.plist")

    [ ! -f "${RECEIPT_FILES[0]}" ] && echo -e "$info Nothing to remove. Exiting..." && exit 0
    
    echo -e "$info Command Line Tools installed. Removing..."
    
    # Need to be at root
    cd /
    # Remove files and dirs mentioned in the "Bill of Materials" (BOM)
    for bom in "${RECEIPT_FILES[@]}"
    do
        lsbom -fls $bom | sudo xargs -I{} rm -r "{}"
        sudo rm $bom
    done

    # remove the plists
    for plist in "${RECEIPT_PLISTS[@]}"
    do
        sudo rm $plist
    done

    echo "$info Done! If XCode is running, restart it to have Command Line Tools appear as uninstalled."
}

# Make sure only root can run our script
check_root
# Detect and set the version of OS X for the rest of the script
detect_osx_version
# Uninstall the Command Line Tools
uninstall_tools
