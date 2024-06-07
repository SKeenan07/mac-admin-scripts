#!/bin/zsh

# Sarah Keenan - January 13, 2021
# This script automatically logs out the logged in user after a specified idle time. 

##### Functions

prompt () {
	JAMF_HELPER="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
	window="utility"
	title="OHIO Idle Logout"
	heading="This Mac is idle."
	message='This Mac has been idle for more than 15 minutes. Click the "More Time" button to continue using this Mac. Otherwise, an automatic logout will occur and all unsaved documents will be LOST!'
	icon="/Library/Application Support/JAMF/bin/brandingimage.png"
	buttonone="Log Out" # $answer will be 0 if selected
	buttontwo="More Time" # $answer will be 2 if selected
	timeout="300" # $answer will be 0 if the popup times out

	"$JAMF_HELPER" -windowType "$window" -title "$title" -heading "$heading" -description "$message" -icon "$icon" -button1 "$buttonone" -button2 "$buttontwo" -timeout "$timeout" -countdown
}

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

getIdleTime () {
	ioreg -c IOHIDSystem | awk '/HIDIdleTime/ { print $NF/1000000000 }' | sed 's|\.| |g' | awk '{ print $1 }'
}

logoutUser () {
	sudo launchctl bootout user/$(id -u ${1})
}

##### Variables

maxIdleTime=900 # 15 minutes

currentUser=$(stat -f%Su /dev/console)
echo "Current User: $currentUser"

# Are users logged in?
# loggedInUsers=$(last | grep "still logged in" | grep "console" | awk '{print $1}')
loggedInUsers=$(last | grep "still logged in" | awk '{print $1}' | sort -u)
echo "Logged in Users: $loggedInUsers"

# If there are users logged in, get the idle time
if [[ -n "$loggedInUsers" ]]; then

	for user in ${(f)loggedInUsers[@]}; do

		# If the user is not the current user, log them out
		if [[ "$user" != "$currentUser" ]]; then
			echo "$user is not the current user."
			echo "Logging out $user..."
			logoutUser $user

		# If the user is the current user, get the idle time
		else
			idleTime=$(getIdleTime)
			echo "Idle Time for $currentUser: $idleTime"
			
			# If the idle time is greater than the max idle time, prompt the user
			if (( $idleTime > $maxIdleTime )); then
				echo "Idle Time is greater than $maxIdleTime. Logging out $currentUser..."
				quitRunningApplications
				logoutUser $user
			fi

		fi

	done

fi
