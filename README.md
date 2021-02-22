# Mac Admin Scripts

## [Auto Logout](https://github.com/SKeenan07/mac-admin-scripts/tree/main/auto-logout)

Click the header above for more info about my auto-logout script. 

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
