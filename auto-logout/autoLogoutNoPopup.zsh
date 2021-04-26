#!/bin/zsh

# Sarah Keenan - January 13, 2021
# This script automatically logs out the logged in user after a specified idle time. 

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
	
		if [[ $answer == 0 ]]; then
			quitRunningApplications			
			currentUser=$(stat -f%Su /dev/console)
			sudo launchctl bootout user/$(id -u $currentUser)
		fi
	fi
fi
