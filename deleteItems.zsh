#!/bin/zsh

fail () {
    echo "ERROR: $2"
    exit $1
}

# If parameter 4 is not empty, set it to the delimiter
if [[ -n "$4" ]]; then
    delimiter="$4"
else
    fail 40 "NO DELIMITER SPECIFIED"
fi

# If parameter 5 is not empty and it exists, set it to the folder
if [[ -n "$5" ]] && [[ -e "$5" ]] && [[ "$5" =~ "^\/.+\/$" ]]; then
    folder="$5"
elif [[ -n "$5" ]] && [[ ! -e "$5" ]]; then
    fail 51 "SPECIFIED FOLDER, $5, DOES NOT EXIST."
elif [[ -n "$5" ]] && [[ ! "$5" =~ "^\/.+\/$" ]]; then
    fail 52 "SPECIFIED FOLDER, $5, DOES NOT MATCH REGEX."
else
    fail 50 "NO FOLDER SPECIFIED."
fi

# If parameter 6 is not empty, separate the items and add to the array
if [[ -n "$6" ]]; then
    OIFS=$IFS
    IFS="$delimiter"
    read -r -A itemsToDelete <<< "$6"
    IFS=$OIFS
else
    fail 60 "NO ITEMS SPECIFIED."
fi

# If parameter 7 is not empty and is a number, set the max depth
if [[ -n "$7" ]] && [[ "$7" =~ "[0-9]+" ]]; then
    maxDepth=$7
elif [[ -n "$7" ]] && [[ ! "$7" =~ "[0-9]+" ]]; then
    fail 71 "SPECIFIED VALUE, $7, DOES NOT MATCH REGEX"
else
    maxDepth=1
fi

# For every item, delete it if it exists
for item in ${itemsToDelete[@]}; do

    fullPath=$(find "$folder"  -maxdepth "$maxDepth" -iname "$item")

    if [[ -n "$fullPath" ]]; then
        for i in ${(f)fullPath[@]}; do
            echo "$i exists."
            echo "Deleting $i..."
            rm -rf "$i" && echo "Deleted $i"
        done
    else
        echo "$item does not exist."
    fi
	echo "---"
done
