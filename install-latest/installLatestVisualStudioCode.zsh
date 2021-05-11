#!/bin/zsh

# Sarah Keenan - April 30, 2021
# This script installs the latest version of VS Code if it is not installed.

appPath="/Applications"
appName="Visual Studio Code"
downloadURL="https://go.microsoft.com/fwlink/?LinkID=2156837"
tmpFile="tmp.zip"


exitScript () {
    echo "$2"
    exit "$1"
}

isAppInstalled () {
    if [[ -e "/Applications/$appName.app" ]]; then
        echo "yes"
    else
        echo "no"
    fi
}

installApp () {
    # Dowonload the latest version
    echo "Downloading $appName..."
    curl -sLo /tmp/tmp.zip $downloadURL

    # Unzip
    echo "Unzipping..."
    ditto -x -k "/tmp/$tmpFile" "/tmp"

    # Copy to the destination folder
    echo "Copying to $appPath..."
    ditto "/tmp/$appName.app" "$appPath/$appName.app"

    # Clean up
    echo "Removing files from /tmp..."
    rm -rf "/tmp/$tmpFile"
    rm -rf "/tmp/$appName.app"
}

isAppUpdated () {
    installedVersion=$(defaults read "/Applications/$appName.app/Contents/Info.plist" CFBundleShortVersionString)
    if [[ -z "$latestVersion" ]]; then
        exitScript 1 "Could not get latest version."
    elif [[ "$latestVersion" == "$installedVersion" ]]; then
        echo "yes"
    elif [[ "$latestVersion" != "$installedVersion" ]]; then
        echo "no"
    fi
}

installed=$(isAppInstalled)

if [[ "$installed" == "no" ]]; then

    echo "$appName is not installed."

    installApp
    installed=$(isAppInstalled)

    if [[ "$installed" == "no" ]]; then
        exitScript 1 "ERROR: Failed to Install $appName"
    elif [[ "$installed" == "yes" ]]; then
        echo "Successfully installed $appName"
    fi

elif [[ "$installed" == "yes" ]]; then

    latestVersion=$(curl -fsL "https://code.visualstudio.com/Updates" | grep "/darwin" | grep -oiE ".com/([^>]+)([^<]+)/darwin" | cut -d "/" -f 2 | sed $'s/[^[:print:]\t]//g' | head -1 )

    updated=$(isAppUpdated)

    if [[ "$updated" == "no" ]]; then
        echo "Updating $appName to $latestVersion..."

        installApp
        updated=$(isAppUpdated)

        if [[ "$updated" == "no" ]]; then
            exitScript 1 "ERROR: Failed to update $appName to $latestVersion"
        elif [[ "$updated" == "yes" ]]; then
            echo "Successfully updated $appName to $latestVersion"
        fi

    elif [[ "$updated" == "yes" ]]; then
        echo "$appName is on the latest version"
    fi
fi
