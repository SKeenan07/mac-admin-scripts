#!/bin/zsh

# Sarah Keenan - 02-14-2022
# This script uninstalls the Adobe application(s) specified in the input parameter(s)

# Sources:
# https://maclabs.jazzace.ca/2020/11/01/unistalling-adobe-apps.html
# https://helpx.adobe.com/enterprise/kb/apps-deployed-without-base-versions.html
# https://helpx.adobe.com/enterprise/using/uninstall-creative-cloud-products.html#using-maco-terminal

declare -A adobeApps
adobeApps[AEFT]="After Effects"
adobeApps[FLPR]="Animate"
adobeApps[AUDT]="Audition"
adobeApps[KBRG]="Bridge"
adobeApps[CHAR]="Character Animator"
adobeApps[ESHR]="Dimension"
adobeApps[DRWV]="Dreamweaver"
adobeApps[ILST]="Illustrator"
adobeApps[AICY]="InCopy"
adobeApps[IDSN]="InDesign"
adobeApps[LRCC]="Lightroom"
adobeApps[LTRM]="Lightroom Classic"
adobeApps[AME]="Media Encoder"
adobeApps[PHSP]="Photoshop"
adobeApps[PRLD]="Prelude"
adobeApps[PPRO]="Premiere Pro"
adobeApps[RUSH]="Premiere Rush"
adobeApps[SBSTD]="Substance Designer"
adobeApps[SBSTP]="Substance Painter"
adobeApps[SBSTA]="Substance Sampler"
adobeApps[STGR]="Substance Stager"
adobeApps[SPRK]="XD"

inputParameters=( "$4" "$5" "$6" "$7" "$8" "$9" "${10}" "${11}" )

sumOfExitCodes=0
failed=0 # Set counter for failed uninstalls
uninstalled=0 # Set counter for successful uninstalls

for i in ${inputParameters[@]}; do

    index=${inputParameters[(ie)$i]}
    parameter=$( expr $index + 3 )
    
    echo "Parameter $parameter: $i"
    sapCode=$(echo "$i" | awk '{ print $1 }')
    version=$(echo "$i" | awk '{ print $2 }')

    # If the input parameter doesn't match the proper format, then log error
    # Proper format includes 3-5 character SAP code and versions
    # such as 1.0, 1.0.0, 1.0.00, 10.0, 10.0.0, and 10.0.00
    # Link to regex: https://regex101.com/r/CodSgC/1
    if [[ ! "$i" =~ "^[A-Z]{3,5}[ ][0-9]{1,2}[.][0-9]{1}($|([.][0-9]{1,2})$)" ]]; then

        echo "Error: Parameter $parameter does not match the format"
        echo "The parameter must contain the 3-5 character short code and the base version to uninstall, such as ILST 25.4"

    # If the SAP Code is not in the array, then log error and show SAP Codes
    elif [[ -z ${adobeApps[(ie)$sapCode]} ]]; then

        echo "Error: SAP Code, $sapCode, is incorrect"
        echo "SAP Codes are as follows"
        for key value in ${(kv)adobeApps}; do
            printf "$key\t$value\n"
        done
        let failed++ # Increment number of failed uninstalls

    # Uninstall specified app
    else
        echo "Uninstalling ${adobeApps[$sapCode]} $version..."
        sudo "/Library/Application Support/Adobe/Adobe Desktop Common/HDBox/Setup" --uninstall=1 --sapCode="$sapCode" --baseVersion="$version" --platform=osx10-64 --deleteUserPreferences=false
        exitCode=$?
        sumOfExitCodes=$( expr $sumOfExitCodes + $exitCode )

        # If the exit code is greater than 0, log error and increment number of failed uninstalls
        if [[ $exitCode -ne 0 ]]; then
            echo "Failed to uninstall ${adobeApps[$sapCode]}"
            let failed++

        # Increment the number of successful installs
        else
            let uninstalled++
        fi
    fi
    echo ""
done

# If the sum of the exit codes is not 0, the display the number of failed and
# successful uninstalls and exit with the number of failed uninstalls
if [[ $sumOfExitCodes -ne 0 ]]; then
    echo "$failed apps failed to uninstall"
    echo "$uninstalled apps successfully uninstalled"
    exit $failed
else
    exit 0
fi
