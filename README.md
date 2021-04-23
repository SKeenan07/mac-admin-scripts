# Mac Admin Scripts

## [Auto Logout](https://github.com/SKeenan07/mac-admin-scripts/tree/main/auto-logout)

Click the header above for more info about my auto-logout script. 

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

## [setupWithDEPNotify.zsh](https://github.com/SKeenan07/mac-admin-scripts/blob/main/setupWithDEPNotify.zsh)

This script uses [input parameters](https://www.jamf.com/jamf-nation/articles/146/script-parameters) to configure DEPNotify and specify the custom triggers for the policies to run.

**Parameter Labels:**

4. Main Text - Message to display in the DEPNotify window. Use /n to create new line. (Yes, use /n not \n.) If not specified, a default message will appear.
5. Complete Action [Quit | Restart] - Action when the process completes. Default is Quit.
6. Complete Message - Message to display when setup completes. If not specified, a default message will appear. (max. 120 characters)
7. Policy Custom Triggers (at least 1 is required) - This supports multiple custom triggers separated by a space. (No custom trigger should have a space in it.)

Parameters eight through eleven should have the same label as parameter seven.

**Parameter Values in the Policy:**

- Main Text: The message you want to display in the DEPNotify Window. The following message will appear if this parameter is left empty:

  > We are setting up this Mac with a standard quite of software and security settings, including every day apps, configuration profiles and security policies. 
  >
  > This process could take up to 20 minutes, so please don't restart or shutdown this Mac until we are done.
  
- Complete Action: The action you want to be executed when setup is completed. The default is Quit if this parameter is left empty. 
- Complete Message: The message you want to display when setup is completed. The following message will appear if this parameter is left empty: 

  > Setup is now complete. Please click Quit.
  
- Policy Custom Triggers: The custom triggers for the policies you want to run during setup. Multiple custom triggers can be specified in one parameter. 

For a [full list of configurations](https://gitlab.com/Mactroll/DEPNotify) and to [download DEPNotify](https://gitlab.com/Mactroll/DEPNotify/-/releases), see the project on GitLab. 
