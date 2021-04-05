#!/bin/zsh

# Sarah Keenan - April 5, 2021
# This script deletes all users that have not logged in within the last 10 days.

nonSystemUsers=$(dscl . list /Users | grep -v "^_")

usersToExclude=("daemon" "nobody" "root")

# If parameter 4 is not empty, add each item to the array
if [[ -n $4 ]]; then
    parameter4=$(echo $4 | tr ' ' '\n')
    for i in ${(f)parameter4}; do
        usersToExclude+=( "$i" )
    done
fi

# For every non system user, if it is not a user to exclude, add it to the array
for i in ${(f)nonSystemUsers}; do
    if [[ ${usersToExclude[(r)$i]} != $i ]]; then
        users+=( "$i" )
    fi
done

todayInSeconds=$(date -j $(date +%d%m%y) +%s)

# For every user, get the last login
for i in ${users[@]}; do
    lastLogin=$(last -1 $i)

    # If the user is not logged in, determine the number of days since the last login
    if [[ "$lastLogin" != *"still logged in"* ]]; then
        lastLoginTime=$(echo $lastLogin | awk '{ print $5, $4 }')
        lastLoginInSeconds=$(date -j -f "%d %b" $lastLoginTime +%s)
        difference=$(expr $todayInSeconds - $lastLoginInSeconds)
        days=$(( $difference/(24*3600) ))

        # If the number of days are negative, it is because the last login was in the previous year
        if [[ $days -lt 0 ]]; then
            previousYear=$(expr $(date +%Y) - 1)
            lastLoginInSeconds=$(date -j -f "%d %b %Y" "$lastLoginTime $previousYear" +%s)
            difference=$(expr $todayInSeconds - $lastLoginInSeconds)
            days=$(( $difference/(24*3600) ))
        fi

        # If the user has not logged in for 10 or more days, delete the user account and home directory
        if [[ "$days" -ge 10 ]]; then
            echo "$i has not logged in for $days days."
            echo "Deleting account, $i..."
            sudo dscl . -delete "/Users/$i"
            sudo rm -rf  "/Users/$i"
        fi
    fi
done
