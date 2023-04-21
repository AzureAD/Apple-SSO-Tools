# Apple SSO Tools

The Apple SSO Tools repo is a collection of scripts for troubleshooting common issues with features such as the [Microsoft Enteprise SSO Extension Plugin](https://learn.microsoft.com/en-us/mem/intune/configuration/use-enterprise-sso-plug-in-ios-ipados-macos?pivots=all). 

For additional troubleshooting guidance please read the [Troubleshooting the Microsoft Enterprise SSO Extension plugin on Apple Devices](https://learn.microsoft.com/en-us/azure/active-directory/devices/troubleshoot-mac-sso-extension-plugin)

## SSOE Troubleshooter

The SSOE Troubleshooter is made up of 3 scripts written in zsh.

1.) SSOETroubleshoot.zsh - This is the main launching script.

2.) checkurls.sh- This is used to do network connectivity checks to the proper urls.

3.) featureflags.zsh- This is used to check common configuration settings pushed down from the MDM.

## Running SSOE Troubleshooter

**Note:** Make sure you have execute permissions on the script. 'chmod +x *scriptname*.zsh'

1.) Download all 3 files to the machine you want to troubleshoot.

2.) From a terminal prompt, navigate to the directory where all 3 files are, run ./SSOETroubleshoot.zsh

3.) Follow the menu prompt entering either '1' for network connectivity testing or '2' for checking the configuration of the SSSOE plugin. Enter 'q' to quit the tool.

## Support
For issues, questions, and feature requests please review the guidance on the [Support](https://github.com/AzureAD/Apple-SSO-Tools/blob/main/SUPPORT.md) page for this project for filing issues.
## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft 
trademarks or logos is subject to and must follow 
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.
