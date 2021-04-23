#!/bin/zsh

fail () {
    echo "ERROR: $2"
    exit $1
}

jamfBinary="/usr/local/jamf/bin/jamf"

# If parameter 4 is not empty and it matches the regex, set to install application name
if [[ -n "$4" ]] && [[ "$4" =~ "^Install macOS [A-Za-z ]+.app$" ]]; then
    installApp="$4"
elif [[ -n "$4" ]] && [[ ! "$4" =~ "^Install macOS [A-Za-z ]+.app$" ]]; then
    fail 41 "INSTALL APP DOES NOT MATCH FORMAT. MUST FOLLOW THE FOLLOWING FORMAT: Install macOS [Name].app"
else
    fail 40 "INSTALL APP NOT SPECIFIED"
fi

# If parameter 5 is not empty, set to custom trigger
if [[ -n "$5" ]]; then
    customTrigger="$5"
else
    fail 50 "CUSTOM TRIGGER TO INSTALL INSTALL APP NOT SPECIFIED"
fi

# If the Install macOS Application does not already exist, install it
if [[ ! -e "/Applications/$installApp" ]]; then
    echo "Installing $installApp..."
    sudo "$jamfBinary" policy -event "$customTrigger"
fi

# If the Install macOS Application still does not exist, exit
if [[ ! -e "/Applications/$installApp" ]]; then
    fail 1 "FAILED TO INSTALL INSTALL APP. MAKE SURE THAT THE CUSTOM TRIGGER IS CORRECT AND THE COMPUTER IS IN THE SCOPE."
fi

installAppVersion=$(defaults read /Applications/$installApp/Contents/Info.plist CFBundleShortVersionString | awk -F. '{ print $1 }')

# If the install app is lower than version 15 (Catalina), run startosinstall without the forcequitapps flag
if [[ "$installAppVersion" -lt 15 ]]; then
    '/Applications/$installApp/Contents/Resources/startosinstall' --agreetolicense --eraseinstall && kill $(pgrep "Self Service")
else
    '/Applications/$installApp/Contents/Resources/startosinstall' --agreetolicense --forcequitapps --eraseinstall && kill $(pgrep "Self Service")
fi
