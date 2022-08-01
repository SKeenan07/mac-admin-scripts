#!/bin/zsh

# Sarah Keenan - October 6, 2021
# This script uninstalls the printers specified in the input patameters

declare -a printersToRemove
printersToRemove=(
    "$4"
    "$5"
    "$6"
    "$7"
    "$8"
    "$9"
    "${10}"
    "${11}"
)

installedPrinters=$(lpstat -a | awk '{ print $1 }')

for printer in ${printersToRemove[@]}; do
    if [[ "$installedPrinters" == *"$printer"* ]]; then
        lpadmin -x "$printer"
    else
    	echo "$printer is not installed"
    fi
done
