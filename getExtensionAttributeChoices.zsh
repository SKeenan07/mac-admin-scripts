#!/bin/zsh

apiUser="your_api_username"
apiPass="your_api_password"
apiURL="https://your.jamf.url.com"
EA_ID="ea_id_number"

EA_All=$(curl -X GET -fku $apiUser:$apiPass "$apiURL/JSSResource/computerextensionattributes/id/$EA_ID" -H "Content-Type: application/xml" | xmllint --format -)
choices=$(echo $EA_All | grep "<choice>" | sed -e $'s|<choice>||g' | sed -e $'s|</choice>||g' | sed -e $'s|^[[:space:]]*||g')

for i in ${(f)choices}; do
    echo "$i"
done
