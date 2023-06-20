#!/bin/zsh
: <<COMMENT
.SYNOPSIS
    Microsoft Enteprise SSO Extension Configuration Troubleshooter Menu Launcher.

.VERSION
    1.0

.DATE
    21-04-23

.DESCRIPTION
    This script outputs a menu to launch additional scripts to troubleshoot common issues. 
    Entering the value of 1 will do a network connectivity check for the correct endpoints. 
    Entering a value of 2 will check common settings used by the Enterprise SSO Extension pushed to the device via the MDM provider. 
    
    This should be used with the the below references to troubleshoot issues with the Microsoft Enterprise SSO Extension.  
    
    References:
        Microsoft Enterprise SSO Extension Plugin for Apple Devices: https://learn.microsoft.com/en-us/azure/active-directory/develop/apple-sso-plugin
        Microsoft Enterprise SSO Extenson Plugin Troubleshooting Guide: https://learn.microsoft.com/en-us/azure/active-directory/devices/troubleshoot-mac-sso-extension-plugin 
        
.USAGE
    Before running the script the first time, use chmod to add execute permissions:
        chmod +x feature.zsh 
        chmod +x checkurls.sh
        chmod +x SSOETroubleshoot.zsh
    To run script:
        ./SSOETroubleshoot.zsh
           


.AUTHOR:
    Identity Customer Experience Engineeering (CxE) MacOS V-Team

.EXAMPLE OUTPUT
    
    Welcome to the macOS Enterprise SSO Troubleshooting Utility





    Please enter 1 to Check Network Connectivity
    Please enter 2 to Check Configuration
    Please enter q to quit


COMMENT

while true; do
    echo
    echo "Welcome to the macOS Enterprise SSO Troubleshooting Utility"
    echo
    echo
    echo 
    echo
    echo
    echo "Please enter 1 to Check Network Connectivity"
    echo "Please enter 2 to Check Configuration"
    echo "Please enter q to quit"
    read -r choice

    case $choice in
        1)
            echo "Executing checkurls.sh script..."
            ./checkurls.sh
            echo "Press enter to return to the menu"
            read
            ;;
        2)
            echo "Executing featureflags.zsh script..."
            ./featureflags.zsh
            echo "Press enter to return to the menu"
            read
            ;;
        q)
            echo "Quitting..."
            break
            ;;
        *)
            echo "Invalid choice. Please enter either 1 or 2 or q to quit."
            ;;
    esac
done
