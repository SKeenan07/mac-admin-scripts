#!/bin/zsh

DEPNotifyLog="/var/tmp/depnotify.log"

computerName=$(scutil --get ComputerName)
currentUser=$(stat -f%Su /dev/console)

# -------------------------- Configure and Open DEPNotify --------------------------

windowStyle="NotMovable"
image="/Library/Application Support/JAMF/bin/brandingImage.png"
mainTitle="Configuring $computerName..."

# If input was passed in parameter 4, then assign to main text
# If input was not passed, then set default message
if [[ -n "$4" ]]; then
	mainText="$4"
else
	mainText="We are setting up this with a standard quite of software and security settings, including every day apps, configuration profiles and security policies. \\\n \\\n This process could take up to 20 minutes, so please don't restart or shutdown this Mac until we are done. \\\n \\\n At the end of this process, you will be prompted to restart this Mac and will be required to enable FileVault on your next login."
fi

echo "Command: WindowStyle: $windowStyle" > ${DEPNotifyLog}
echo "Command: Image: $image" >> ${DEPNotifyLog}
echo "Command: MainTitle: $mainTitle" >> ${DEPNotifyLog}
echo "Command: MainText: $mainText" | tr '/' '\\'>> ${DEPNotifyLog}
echo "Status: Searching for configuration..." >> ${DEPNotifyLog}

sudo -u "$currentUser" open -a /Applications/Utilities/DEPNotify.app # Uncomment when running with Jamf
# open -a /Applications/Utilities/DEPNotify.app # Uncomment for testing locally

# ----------------------------------- Set Up Mac -----------------------------------

parameter7=$(echo "$7" | sed 's| |\n|g')
parameter8=$(echo "$8" | sed 's| |\n|g')
parameter9=$(echo "$9" | sed 's| |\n|g')
parameter10=$(echo "${10}" | sed 's| |\n|g')
parameter11=$(echo "${11}" | sed 's| |\n|g')

declare -a inputParameters
inputParameters=(
    "$parameter7"
    "$parameter8"
    "$parameter9"
	"$parameter10"
    "$parameter11"
)

declare -a customTriggers

# For every parameter
for i in ${inputParameters[@]}; do

	# If the parameter is not empty
	if [[ -n "$i" ]]; then
	
		# For every custom trigger, add it to the array
		for i in "${(f)i}"; do
			customTriggers+=( "$i" )
		done
	fi
done

# Set the number of steps to the size of the customTriggers array
echo "Command: Determinate: ${#customTriggers[@]}" >> ${DEPNotifyLog}

for i in ${customTriggers[@]}; do
	echo "Status: Installing $i..." >> ${DEPNotifyLog}
	sudo jamf policy -event "$i"
done

# --------------------------------- Quit DEPNotify ---------------------------------

# If input was passed in parameter 5 and it is either Quit or Restart, then assign to completeAction
# If input was not passed, then set completeAction to Quit
if [[ -n "$5" ]] && [[ "$5" == "Quit" || "$5" == "Restart" ]]; then
	completeAction="$5"
else
	completeAction="Quit"
fi

# If input was passed in parameter 6, then assign to completeMessage
# If input was not passed, then set default message
if [[ -n "$6" ]] && ; then
	completeMessage="$6"
else
	completeMessage="Setup is now complete. Please click Quit."
fi

echo "Command: $completeAction: $completeMessage" >> ${DEPNotifyLog}
