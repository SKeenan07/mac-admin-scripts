#!/bin/zsh

# Sarah Keenan - April 5, 2021
# This script deletes all users that have not logged in within the last 10 days.

nonSystemUsers=$(dscl . list /Users | grep -v "^_")

usersToExclude=("daemon" "nobody" "root")

debug () {
    if [[ "$debug_mode" == "true" ]]; then
        printf "$1:\t$2\n"
    fi
}

function DecryptString() {
    # Usage: ~$ DecryptString "Encrypted String" "Salt" "Passphrase"
    echo "${1}" | /usr/bin/openssl enc -aes256 -md md5 -d -a -A -S "${2}" -k "${3}"
}

# If parameter 4 is DEBUG set debug_mode to true
if [[ -n $4 ]] && [[ $4 == *"DEBUG"* ]]; then
    debug_mode=true
fi

# If parameter 4 is TESTING set testing_mode to true
if [[ -n $4 ]] && [[ $4 == *"TESTING"* ]]; then
    testing_mode=true
fi

# If parameter 5 is not empty AND it is a number, set the number of inactive days
if [[ -n $5 ]] && [[ $5 =~ "^[0-9]+$" ]]; then
    inactiveDays="$5"
elif [[ -n $5 ]] && [[ ! $5 =~ "^[0-9]+$" ]]; then
    echo "Parameter 5 can only contain digits."
    exit 51
elif [[ -z $5 ]]; then
    echo "No value set for Parameter 5"
    exit 52
fi

# If parameter 6 is not empty, add each item to the array
if [[ -n $6 ]]; then
    array=$(echo $6 | tr ' ' '\n')
    for i in ${(f)array}; do
        usersToExclude+=( "$i" )
    done
fi

if [[ -n "$8" ]] && [[ -n "$9" ]] && [[ -n "${10}" ]] && [[ -n "${11}" ]]; then
    adminUsername="$8"
    adminPassword=$(DecryptString "$9" "${10}" "${11}")
else
    echo "No value(s) for Admin Username/Password"
    exit 80
fi

# For every non system user, add it to the array
for i in ${(f)allUsers}; do
    if [[ ${usersToExclude[(r)$i]} != $i ]]; then
            users+=( "$i" )
    else
        debug "Excluding" "$i"
    fi
done

debug "Users to check" "${users[*]}"

# Get today's date in seconds
# todayInSeconds=$(date -j $(date +%d%m%y) +%s)
today=$(date +%D)
todayInSeconds=$(date -j -f "%D %H:%M:%S" "$today 23:59:59" +%s)
debug "Today" "$(date -j -f %s "$todayInSeconds" "%D %H:%M:%S")"

debug "Today in seconds" "$todayInSeconds"

# For every user, get the last login
for i in ${users[@]}; do
    echo "----- $i -----"
    lastLogin=$(last -1 $i)
    debug "$i's last login" "$lastLogin"
    # If the user is not logged in, determine the number of days since the last login
    if [[ "$lastLogin" != *"still logged in"* ]]; then
        lastLoginTime=$(echo $lastLogin | grep -Eo "([A-Z][a-z]{2}[ ]){2}(([0-9]{2})|([ ][0-9]))[ ][0-9]{2}[:][0-9]{2}")
        debug "$i's last login time" "$lastLoginTime"
        lastLoginInSeconds=$(date -j -f "%a %b %d %H:%M" "$lastLoginTime" "+%s")
        debug "$i's last login time (s)" "$lastLoginInSeconds"
        difference=$(expr $todayInSeconds - $lastLoginInSeconds)
        debug "Login difference" "$difference"
        days=$(( $difference/(24*3600) ))
        debug "Login difference (d)" "$days"

        # If the number of days are negative, it is because the last login was in the previous year
        if [[ $days -lt 0 || $difference -lt 0 ]]; then
            previousYear=$(expr $(date +%Y) - 1)
            debug "Real last login time" "$lastLoginTime $previousYear"
            lastLoginInSeconds=$(date -j -f "%a %b %d %H:%M %Y" "$lastLoginTime $previousYear" +%s)
            difference=$(expr $todayInSeconds - $lastLoginInSeconds)
            debug "Real login difference" "$difference"
            days=$(( $difference/(24*3600) ))
            debug "Real login difference (d)" "$days"
        fi

        # If the user has not logged in for 10 or more days, delete the user account and home directory
        if [[ "$days" -ge "$inactiveDays" ]]; then
            echo "$i has not logged in for $days days."
            if [[ "$testing_mode" == "true" ]]; then
                echo "Testing mode enabled. NOT deleting account, $i..."
            else
            	echo "Deleting account, $i..."
#                sudo dscl . -delete "/Users/$i" || 
				sysadminctl -deleteUser "$i" -adminUser "$adminUser" -adminPassword "$adminPassword" #2&>1
                echo $?
#                sudo rm -rf "/Users/$i"
            fi
        else
            echo "$i last logged in $days day(s) ago."
        fi
    else
        echo "$i is still logged in."
    fi
done
