#!/bin/zsh

# Sarah Keenan - May 6, 2021
# This script installs the latest version of iTerm2 if it is not installed.

appPath="/Applications"
appName="iTerm"
downloadURL="https://iterm2.com/downloads/stable/latest"
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

    # From installomator
    latestVersion=$(curl -is https://iterm2.com/downloads/stable/latest | grep location: | grep -o "iTerm2.*zip" | cut -d "-" -f 2 | cut -d '.' -f1 | sed 's/_/./g')

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

echo "Suppressing move to Applications folder alert..."
currentUser=$(stat -f%Su /dev/console)
sudo -u "$currentUser" defaults write com.googlecode.iterm2 moveToApplicationsFolderAlertSuppress -bool true
