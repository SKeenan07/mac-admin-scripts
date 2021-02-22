#!/bin/sh

# Sarah Keenan - February 15, 2021
# This script runs an install application inside of a dmg

fail () {
	echo "ERROR: $2"
	exit "$1"
}

# Wait 30 second after caching the dmg
sleep 30

dmgPath="/Library/Application Support/JAMF/Waiting Room/"

# Set DMG
# If input was passed in Parameter 4 AND the input contains .dmg AND the DMG exists, set the DMG to the parameter
# If input was passed in Parameter 4 AND the input DOES NOT contain .dmg AND the DMG.dmg exists, set the DMG to the parameter
# If input was not passed in Parameter 4, exit
# If input the dmg does not exist at the dmg path, exit
if [[ -n "$4" ]] && [[ "$4" == *".dmg"* ]] && [[ -e "$dmgPath$4" ]]; then
	dmg="$4"
elif [[ -n "$4" ]] && [[ "$4" != *".dmg"* ]] && [[ -e "$dmgPath$4.dmg" ]]; then
	dmg="$4.dmg"
elif [[ -z "$4" ]]; then
	fail "40" "NO DMG SPECIFIED"
elif [[ ! -e "$dmgPath$4" ]]; then
	fail "41" "SPECIFIED DMG, $dmg, DOES NOT EXIST"
else
	fail "42" "PROBLEM WITH DMG VARIABLE, $dmg"
fi

# Set Volume
# If input was passed in Parameter 5, then set the volume name to the input
if [[ -n "$5" ]]; then
	volume="$5"
else
	fail "50" "NO VOLUME NAME SPECIFIED"
fi

# Mount DMG
/usr/bin/hdiutil attach "$dmgPath$dmg" -nobrowse -quiet

if [[ ! -e "/Volumes/$volume" ]]; then
	fail "51" "VOLUME DOES NOT EXIST"	
fi

# Set Install Application
# If input was passed in Parameter 6 AND it contains .app AND the install app exists, then set installApplication to the input
# If input was passed in Parameter 6 AND it DOES NOT contains .app AND the install app.app exists, then set installApplication to the input
# If input was not passed in Parameter 6, exit
# If input the install app does not exist at the volume path, exit
if [[ -n "$6" ]] && [[ "$6" == *".app"* ]] && [[ -e "/Volumes/$volume/$6" ]]; then
	installApplication="$6"
elif [[ -n "$6" ]] && [[ "$6" != *".app"* ]] && [[ -e "/Volumes/$volume/$6.app" ]]; then
	installApplication="$6.app"
elif [[ -z "$6" ]]; then
	fail "60" "NO INSTALL APPLICATION SPECIFIED"
elif [[ ! -e "/Volumes/$volume/$6" ]]; then
	fail "61" "SPECIFIED INSTALL APPLICATION, $installApplication, DOES NOT EXIST"
else
	fail "62" "PROBLEM WITH INSTALL APPLICATION VARIABLE, $installApplication"
fi

# Set Install Options / Flags
if [[ -n "$7" ]]; then
	installOptions="$7"
fi

# Get executable
executable=$(ls "/Volumes/$volume/$installApplication/Contents/MacOS/")

# Run Installer
sudo "/Volumes/$volume/$installApplication/Contents/MacOS/$executable" "$installOptions"

# Unmount Volume
/usr/bin/hdiutil detach "/Volumes/$volume" -quiet

# Delete Cached DMG
rm -rf "$dmgPath$dmg"*
