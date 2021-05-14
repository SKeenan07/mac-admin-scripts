#!/bin/zsh

installedMajorOS_Version=$(sw_vers -productVersion | awk -F. '{ print $1 }')
installedMinorOS_Version=$(sw_vers -productVersion | awk -F. '{ print $2 }')
installedMajorMinorVersion="$installedMajorOS_Version.$installedMinorOS_Version"

current_macOS=$(curl -s "https://jamf-patch.jamfcloud.com/v1/software/303" | grep currentVersion | tr -d '"' | awk '{ print $2 }')
currentMajorOS_Version=$(echo $current_macOS | awk -F. '{ print $1 }')

minusTwo=$(expr $currentMajorOS_Version - 2)
minusOne=$(expr $currentMajorOS_Version - 1)

if [[ $minusTwo -le 10 ]]; then
    if [[ $minusTwo -eq 9 ]]; then
        minusTwo=10.14
        minusOne=10.15
    elif [[ $minusTwo -eq 10 ]]; then
        minusTwo=10.15
    fi
fi

if [[ $installedMajorMinorVersion =~ "^$minusTwo" ]] || [[ $installedMajorMinorVersion =~ "^$minusOne" ]] || [[ $installedMajorMinorVersion =~ "^$currentMajorOS_Version" ]]; then
    echo "true"
else
    echo "false"
fi
