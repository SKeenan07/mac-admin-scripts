# Adobe

## [uninstallSpecificAdobeApplications.zsh](./uninstallSpecificAdobeApplications.zsh)

This script will uninstall the Adobe applications specified in the input parameters. 
In each parameter, specify the Sap Code for the application and the base version, such as `PHSP 23.0`. 
See Adobe's [Applications that can be deployed without base versions](https://helpx.adobe.com/enterprise/kb/apps-deployed-without-base-versions.html) 
article for the Sap Codes and base versions. 

See [here](https://helpx.adobe.com/enterprise/using/uninstall-creative-cloud-products.html#using-maco-terminal) 
for more information about uninstalling specific Adobe applications.

This script will check to make sure each input parameter matches the following regex: 

```
^[A-Z]{3,5}[ ][0-9]{1,2}[.][0-9]{1}($|([.][0-9]{1,2})$)
```

You can test this regex [here](https://regex101.com/r/CodSgC/1).

The exit code for this script will equal the number of failed uninstalls.
