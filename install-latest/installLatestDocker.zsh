#!/bin/zsh

# Sarah Keenan - May 26, 2021
# This script installs the latest version of Docker if it is not installed.

appPath="/Applications"
appName="Docker"
tmpFile="Docker.dmg"

# From Installomator
if [[ $(arch) == arm64 ]]; then
    downloadURL="https://desktop.docker.com/mac/stable/arm64/Docker.dmg"
elif [[ $(arch) == i386 ]]; then
    downloadURL="https://desktop.docker.com/mac/stable/amd64/Docker.dmg"
fi

exitScript () {
    echo "$2"
    exit "$1"
}

isAppInstalled () {
    if [[ -e "$appPath/$appName.app" ]]; then
        echo "yes"
    else
        echo "no"
    fi
}

installApp () {
    # Dowonload the latest version
    echo "Downloading $appName..."
    curl -sLo /tmp/$tmpFile $downloadURL

    # Mounting DMG
    echo "Mounting DMG..."
    /usr/bin/hdiutil attach /tmp/$tmpFile -nobrowse -quiet

    # Copy to the destination folder
    echo "Copying to $appPath..."
    ditto "/Volumes/$appName/$appName.app" "$appPath/$appName.app"

    # Clean up
    echo "Removing files from /tmp..."
    rm -rf "/tmp/$tmpFile"
    /usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep "$appName" | awk '{ print $1 }') -quiet

    # Install Docker Privileged Components
    echo "Installing Docker Privileged Components..."
    sudo /Applications/Docker.app/Contents/MacOS/Docker --install-privileged-components
}

isAppUpdated () {
    installedVersion=$(defaults read "$appPath/$appName.app/Contents/Info.plist" CFBundleShortVersionString)
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

    latestVersion=$(curl -ifs https://docs.docker.com/desktop/mac/release-notes/ | grep "id=\"docker-desktop-" | head -n1 | grep -oE "[0-9]{1,}.[0-9]{1,}.[0-9]{1,}")

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
