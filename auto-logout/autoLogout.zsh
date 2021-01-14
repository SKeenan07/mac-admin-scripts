#!/bin/zsh

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
			sudo shutdown -r now
		fi
	fi
fi
