# Mac Admin Scripts

## [Auto Logout](https://github.com/SKeenan07/mac-admin-scripts/tree/main/auto-logout)

Click the header above for more info about my auto-logout script. 

## [Install Latest](https://github.com/SKeenan07/mac-admin-scripts/tree/main/install-latest)

The scripts in this folder install the latest version of the app if it is not already installed.

## [Setup with DEPNotify](https://github.com/SKeenan07/mac-admin-scripts/tree/main/setup-with-depnotify)

Click the header above for more info about my DEPNotify setup scripts. 

## [deleteInactiveUsers.zsh](https://github.com/SKeenan07/mac-admin-scripts/blob/main/deleteInactiveUsers.zsh)

This script deletes users that have not logged in within the last ten days. This script users input parameter 4 for adding additional users to exclude from being deleted. Each username should be separated by a space

**Parameter 4 Label:** Users to NOT Delete (separate usernames with a space)

**Example Parameter Value in Policy:** yourJamfManagementAccount otherAccountToKeep1 otherAccountToKeep2

## [deleteItems.zsh](https://github.com/SKeenan07/mac-admin-scripts/blob/main/deleteItems.zsh)

This script deletes items specified in the [input parameters](https://www.jamf.com/jamf-nation/articles/146/script-parameters).

**Parameters:**

4. Delimiter (The character that separates the items to delete, such as a comma.)
5. Folder to delete items from (The folder path must begin and end with a `/`.)
6. Items to delete

**Error Codes**

- `40 = No delimiter specified`
- `50 = No folder specified`
- `51 = Specified folder does not exist`
- `52 = Specified folder does not match regex`
- `60 = No items specified`

## [eraseAndInstallMacOS.zsh](https://github.com/SKeenan07/mac-admin-scripts/blob/main/eraseAndInstallMacOS.zsh)

This script erases and reinstalls the macOS specified in the [input parameters](https://www.jamf.com/jamf-nation/articles/146/script-parameters). 

**Parameters:**

4. Name of macOS installer (e.g. Install macOS Big Sur.app)
5. Custom trigger of policy that installs the installer

**Error Codes**

- ` 1 = Failed to install install app`
- `40 = Install app not specified`
- `41 = Install app does not match format`
- `51 = Custom trigger not specified`

## [excelToPlist.applescript](https://github.com/SKeenan07/mac-admin-scripts/blob/main/excelToPlist.applescript)

This script creates an empty plist and gets the used range of an Excel spreadsheet. Then, for every row of the used range, a string key is created with the key set to item 2 and the value set to item 1. 

## [getExtensionAttributeChoices.zsh](https://github.com/SKeenan07/mac-admin-scripts/blob/main/getExtensionAttributeChoices.zsh)

This script gets the choices of a popup computer extension attribute using the [Jamf Classic API](https://www.jamf.com/developers/apis/classic/). The API user will need to have read access to computer extension attributes. 

## [macOSisN-2.zsh](https://github.com/SKeenan07/mac-admin-scripts/blob/main/macOSisN-2.zsh)

This script gets the installed macOS version and the current macOS version from Jamf's macOS patch definition. If the installed macOS version matches a regex of the three most recent macOS versions, then the script returns true. If not, the script returns false. 

## [makeCurrentUserAdmin.sh](https://github.com/SKeenan07/mac-admin-scripts/blob/main/makeCurrentUserAdmin.sh)

This script gets the current user and checks to see if they're an admin. If the current user is not in the admin group, then they are added to the group. 

## [runInstallAppFromDMG.sh](https://github.com/SKeenan07/mac-admin-scripts/blob/main/runInstallAppFromDMG.sh)

This script uses [input parameters](https://www.jamf.com/jamf-nation/articles/146/script-parameters) to run an install application that is inside a DMG. 

**Parameters:**

4. DMG Name
5. Volume Name
6. Install Application Name
7. Install Options / Flags

**Error Codes**

- `40 = No DMG specified`
- `41 = Specified DMG does not exist`
- `42 = Unknown problem with DMG variable`
- `50 = No Volume Name specified`
- `51 = Volume does not exist`
- `60 = No Install Application specified`
- `61 = Specified Install Application does not exist`
- `62 = Unknown problem with Install Application`

## [uninstallMicrosoftOffice.zsh](https://github.com/SKeenan07/mac-admin-scripts/blob/main/uninstallMicrosoftOffice.zsh)

This script follows the instructions from the following Microsoft Support article: [Uninstall Office for Mac](https://support.microsoft.com/en-us/office/uninstall-office-for-mac-eefa1199-5b58-43af-8a3d-b73dc1a8cae3). It removes the following:

- /Applications/Microsoft Excel.app
- /Applications/Microsoft OneNote.app
- /Applications/Microsoft Outlook.app
- /Applications/Microsoft PowerPoint.app
- /Applications/Microsoft Teams.app
- /Applications/Microsoft Word.app
- /Applications/OneDrive.app
- ~/Library/Containers/com.microsoft.errorreporting
- ~/Library/Containers/com.microsoft.Excel
- ~/Library/Containers/com.microsoft.netlib.shipassertprocess
- ~/Library/Containers/com.microsoft.Office365ServiceV2
- ~/Library/Containers/com.microsoft.Outlook
- ~/Library/Containers/com.microsoft.Powerpoint
- ~/Library/Containers/com.microsoft.RMS-XPCService
- ~/Library/Containers/com.microsoft.Word
- ~/Library/Containers/com.microsoft.onenote.mac
- ~/Library/Group Containers/UBF8T346G9.ms
- ~/Library/Group Containers/UBF8T346G9.Office
- ~/Library/Group Containers/UBF8T346G9.OfficeOsfWebHost
- ~/Library/Caches/com.microsoft.teams
- ~/Library/Caches/com.microsoft.teams.shipit
- ~/Library/Application Support/Microsoft/Teams
