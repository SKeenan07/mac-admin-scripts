#!/bin/bash

# Sarah Keenan - January 19, 2021
# This script will grant the current user admin privileges if they are not an admin.

currentUser=$(stat -f%Su /dev/console)

currentAdminPriv=$(dseditgroup -o checkmember -m "$currentUser" admin | awk '{ print $1 }')

if [[ "$currentAdminPriv" == "yes" ]]; then
	echo "The user, $currentUser, is already an admin."
elif [[ "$currentAdminPriv" == "no" ]]; then
	echo "The user, $currentUser, is not an admin."
	echo "Granting admin privileges..."
	/usr/sbin/dseditgroup -o edit -a "$currentUser" -t user admin && echo "Done."
fi
