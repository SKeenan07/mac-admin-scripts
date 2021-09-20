#!/bin/bash

# Sarah Keenan, 09-20-2021
# Change file permissions so the current user owns the file

currentUser=$(stat -f%Su /dev/console)

parameter4=$(echo $4 | sed "s|~/|/Users/$currentUser/|g")
parameter5=$(echo $5 | sed "s|~/|/Users/$currentUser/|g")
parameter6=$(echo $6 | sed "s|~/|/Users/$currentUser/|g")
parameter7=$(echo $7 | sed "s|~/|/Users/$currentUser/|g")
parameter8=$(echo $8 | sed "s|~/|/Users/$currentUser/|g")
parameter9=$(echo $9 | sed "s|~/|/Users/$currentUser/|g")
parameter10=$(echo ${10} | sed "s|~/|/Users/$currentUser/|g")
parameter11=$(echo ${11} | sed "s|~/|/Users/$currentUser/|g")

declare -a inputParameters
inputParameters=(
    "$parameter4"
    "$parameter5"
    "$parameter6"
    "$parameter7"
    "$parameter8"
    "$parameter9"
	"$parameter10"
    "$parameter11"
)

for file in ${inputParameters[@]}; do
    if [[ -e "$file" ]]; then
        #echo "$file exists"
        chown -R "$currentUser" "$file"
    else
        echo "$file does not exist"
    fi
done
