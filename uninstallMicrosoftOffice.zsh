#!/bin/zsh

# Sarah Keenan - March 29, 2021
# This script uninstalls Office. It follows the instructions from 
# https://support.microsoft.com/en-us/office/uninstall-office-for-mac-eefa1199-5b58-43af-8a3d-b73dc1a8cae3

# Get Current User
currentUser=$(stat -f%Su /dev/console)

declare -a toRemove

# Applications
toRemove+=( "/Applications/Microsoft Excel.app" )
toRemove+=( "/Applications/Microsoft OneNote.app" )
toRemove+=( "/Applications/Microsoft Outlook.app" )
toRemove+=( "/Applications/Microsoft PowerPoint.app" )
toRemove+=( "/Applications/Microsoft Teams.app" )
toRemove+=( "/Applications/Microsoft Word.app" )
toRemove+=( "/Applications/OneDrive.app" )

# Containers
toRemove+=( "/Users/$currentUser/Library/Containers/com.microsoft.errorreporting" )
toRemove+=( "/Users/$currentUser/Library/Containers/com.microsoft.Excel" )
toRemove+=( "/Users/$currentUser/Library/Containers/com.microsoft.netlib.shipassertprocess" )
toRemove+=( "/Users/$currentUser/Library/Containers/com.microsoft.Office365ServiceV2" )
toRemove+=( "/Users/$currentUser/Library/Containers/com.microsoft.Outlook" )
toRemove+=( "/Users/$currentUser/Library/Containers/com.microsoft.Powerpoint" )
toRemove+=( "/Users/$currentUser/Library/Containers/com.microsoft.RMS-XPCService" )
toRemove+=( "/Users/$currentUser/Library/Containers/com.microsoft.Word" )
toRemove+=( "/Users/$currentUser/Library/Containers/com.microsoft.onenote.mac" )

# Group Containers
toRemove+=( "/Users/$currentUser/Library/Group Containers/UBF8T346G9.ms" )
toRemove+=( "/Users/$currentUser/Library/Group Containers/UBF8T346G9.Office" )
toRemove+=( "/Users/$currentUser/Library/Group Containers/UBF8T346G9.OfficeOsfWebHost" )

# Teams
toRemove+=( "/Users/$currentUser/Library/Caches/com.microsoft.teams" )
toRemove+=( "/Users/$currentUser/Library/Caches/com.microsoft.teams.shipit" )
toRemove+=( "/Users/$currentUser/Library/Application Support/Microsoft/Teams" )

# Remove every item that exists
for i in ${toRemove[@]}; do
	if [[ -e "$i" ]]; then
		echo "Removing $i..."
		rm -rf "$i"
		if [[ ! -e "$i" ]]; then
			echo "Successfully removed $i"
		else
			echo "Failed to remove $i"
		fi
	fi
done
