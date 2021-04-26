#!/bin/zsh

# Sarah Keenan - January 13, 2021
# This script automatically logs out the Mac after a specified idle time. 

quitRunningApplications () {
	declare -a applications

	allApplications=$(system_profiler SPApplicationsDataType | grep "Location:" | grep -v "/Library/" | sed 's|Location:||g' | sed 's|^[ \t]*||g' | awk -F "/" '{ print $NF }' | sed 's|.app||g')

	# For every custom trigger, add it to the array
	for i in "${(f)allApplications}"; do
		applications+=( "$i" )
	done

	for i in "${applications[@]}"; do 
		process=$(pgrep -x "$i")
		if [[ -n "$process" ]]; then
			n=0
			while [[ -n "$process" ]] && [[ $n < 10 ]]; do
				sudo killall "$i" && sleep 1
				process=$(pgrep -x "$i")
				let n++
			done
		fi
	done
}

# Are users logged in?
loggedInUsers=$(last | grep "still logged in" | grep "console" | awk '{print $1}')

# If there are users logged in, get the idle time
if [[ -n "$loggedInUsers" ]]; then

	idleTime=$(ioreg -c IOHIDSystem | awk '/HIDIdleTime/ { print $NF/1000000000 }' | sed 's|\.| |g' | awk '{ print $1 }')
	maxIdleTime=970

	if (( $idleTime > $maxIdleTime )); then
	
		# Configure Log out Popup
		JAMF_HELPER="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
		window="utility"
		title="Your Organization Idle Logout"
		heading="This Mac is idle."
		message='This Mac has been idle for more than 15 minutes. Click the "More Time" button to continue using this Mac. Otherwise, an automatic logout will occur and all unsaved documents will be LOST!'
		icon="/Library/Application Support/JAMF/bin/brandingimage.png"
		buttonone="Log Out" # $answer will be 0 if selected
		buttontwo="More Time" # $answer will be 2 if selected
		timeout="300" # $answer will be 0 if the popup times out
		
		# Prompt the user
		answer=$("$JAMF_HELPER" -windowType "$window" -title "$title" -heading "$heading" -description "$message" -icon "$icon" -button1 "$buttonone" -button2 "$buttontwo" -timeout "$timeout" -countdown)

		if [[ $answer == 0 ]]; then
			quitRunningApplications			
			currentUser=$(stat -f%Su /dev/console)
			sudo launchctl bootout user/$(id -u $currentUser)
		fi
	fi
fi
