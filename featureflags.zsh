#!/bin/zsh
: <<COMMENT
.SYNOPSIS
    Microsoft Enteprise SSO Extension Configuration Output Module.

.VERSION
    1.0

.DATE
    21-04-23

.DESCRIPTION
    This script outputs the settings configured on the device via the MDM provider for the Enterprise SSO Extension. This should be used with the the below references to troubleshoot issues with the Microsoft Enterprise SSO Extension.  
    
    References:
        Microsoft Enterprise SSO Extension Plugin for Apple Devices: https://learn.microsoft.com/en-us/azure/active-directory/develop/apple-sso-plugin
        Microsoft Enterprise SSO Extenson Plugin Troubleshooting Guide: https://learn.microsoft.com/en-us/azure/active-directory/devices/troubleshoot-mac-sso-extension-plugin 
        
.USAGE
    Before running the script the first time, use chmod to add execute permissions:
        chmod +x feature.zsh 
        chmod +x SSOETroubleshoot.zsh
    To run script:
        ./SSOETroubleshoot.zsh
        Enter "2"    


.AUTHOR:
    Identity Customer Experience Engineeering (CxE) MacOS V-Team

.EXAMPLE OUTPUT
    
    Feature Flag Name							        Value
    browser_sso_interaction_enabled						true
    browser_sso_user_interaction_disabled				true
    disable_explicit_app_prompt_and_autologin			true
    SSOUIPromptDateKey							        Sat Apr 23 16:22:55 PST 2022
    bundleIdOfAppShowingUI							    com.microsoft.teams
    AppPrefixAllowList:PrefixElement				    com.adobe.
    AppAllowList:AllowElement					        com.microsoft.Outlook
    AppAllowList:AllowElement					        com.microsoft.teams
    AppAllowList:AllowElement					        com.microsoft.edgemac
    AppAllowList:AllowElement					        com.microsoft.Word
    AppAllowList:AllowElement					        com.microsoft.onenote.mac
    AppAllowList:AllowElement					        com.microsoft.OneDrive-Mac
    AppAllowList:AllowElement					        com.microsoft.OneDrive
    AppAllowList:AllowElement					        com.microsoft.Excel
    AppAllowList:AllowElement					        com.microsoft.PowerPoint
    AppAllowList:AllowElement					        com.microsoft.to-do-mac
    


    browser_sso_user_interaction_enabled is set to false, which indicates that  Don't ask me to sign in with SSO for this device is enabled in the Company Portal, and will prevent the SSO from acquiring a PRT from the browser.
    We highly recommend that you change (uncheck) this setting in the Company Portal App.
    For more information: https://aka.ms/macssoecpconfig

    Note:
    SSOUIPromptDateKey shows the datetime that the browser/Non-MSAL application was used to invoke the SSO login prompt.
    This doesn't necessarily mean that the PRT was acquired at this time, but it can be a good indication

    bundleIdOfAppShowingUI shows the bundle id of the browser/Non-MSAL application that invoked the SSO login prompt.


COMMENT

appConfig()
{
    #parameters
    local logcontent=$1
    local keyString=$2
    local -a arr

    arr=()
    # Debug # echo "Params in function"
    # Debug # echo "KeyString Value is: "$keyString


    #Find line number where last instance of $keyString Occurs
    line=$(echo $logcontent | grep -n $keyString | tail -n 1 | cut -d ':' -f 1) 
    
    #Find line number where last instance of $keyString Occurs
    element_values=$(echo $logcontent | awk -v start_line=$line -v keyString="$keyString" 'NR < start_line {next} NR >= start_line && index($0, keyString " is (null)") {flag=2;exit} (index($0, keyString " is (") && !index($0, "is (null)")) {flag=1;next}/)/{if(flag==1){flag=0}}flag' | tr -d ',"' | sed 's/^[[:space:]]*//')
    

    # Debug # echo "Line occurs at $line"
    # Debug # echo "Element values are:\n$element_values"
    
    if ((line > 0)); then
        while IFS=, read -r line; do 
            arr+=("${line[@]}")
        done <<< $element_values

       # Debug # echo "Assembled Array: ${arr[@]}"
       # Debug # echo "Array Length: $#arr"
        

        
        for a in "${arr[@]}";
        do
            # Debug # echo "a value is: $a"
            if test -n "$a"; then    

                case $keyString in 
                    "AppPrefixAllowList")
                        echo "AppPrefixAllowList:PrefixElement\t\t\t\t        "$a 
                        ;;
                    "AppAllowList")
                        echo "AppAllowList:AllowElement\t\t\t\t\t        "$a
                        ;;
                    "AppBlockList")
                        echo "AppBlockList:BlockElement\t\t\t\t\t        "$a
                        ;;
                    *)
                    echo
                    ;;
                esac

            fi
        done
    fi
}
validatekey() {
    #parameters
    local key=$1
    local plist_file=$2
    local returnvalue="Invalid"

    output=$(/usr/libexec/PlistBuddy -c "Print :$key" $plist_file 2>&1)
    case $output in
        "true" | "false")
            returnvalue="Valid"
            ;;
        *)
            returnvalue="Invalid"
            ;;
    esac

    echo $returnvalue  # Output the string "Valid" or "Invalid"
}




mbf="Microsoft.Broker.Feature."
key_browser_sso_interaction_enabled=$mbf"browser_sso_interaction_enabled"
key_browser_sso_user_interaction_disabled=$mbf"browser_sso_user_interaction_disabled"
key_disable_explicit_app_prompt=$mbf"disable_explicit_app_prompt"
key_disable_explicit_app_prompt_and_autologin=$key_disable_explicit_app_prompt"_and_autologin"
SSOUIPromptDateKey="SSOUIPromptDateKey"
bundleIdOfAppShowingUI="bundleIdOfAppShowingUI"

#Recommendation Flags
browser_sso_interaction_enabled_flag=0
browser_sso_user_interaction_disabled_flag=0
disable_explict_app_prompt_flag=0
disable_explict_app_prompt_and_autologin_flag=0
disable_explict_app_prompt_overall_flag=0
notesflag=0


# Set the path to your plist file
plist_file="~/Library/Group Containers/UBF8T346G9.com.microsoft.identity.ssoextensiongroup/Library/Preferences/UBF8T346G9.com.microsoft.identity.ssoextensiongroup.plist"
ssoelog_folder="~/Library/Containers/com.microsoft.CompanyPortalMac.ssoextension/Data/Library/Caches/Logs/Microsoft/SSOExtension"

#Expand the tilde character and escape spaces in the file path
plist_file=$(eval echo "$plist_file")
ssoelog_folder=$(eval echo "$ssoelog_folder")


echo "$(tput bold)Feature Flag Name\t\t\t\t\t\t\tValue$(tput sgr0)"

if [ $(validatekey "$key_browser_sso_interaction_enabled" "$plist_file") = "Valid" ]; then
    echo "browser_sso_interaction_enabled\t\t\t\t\t\t"$(/usr/libexec/PlistBuddy -c "Print :$key_browser_sso_interaction_enabled" $plist_file)
    case $(/usr/libexec/PlistBuddy -c "Print :$key_browser_sso_interaction_enabled" $plist_file) in
        "false")
        browser_sso_interaction_enabled_flag=1
        ;;
        *)
        ;;
    esac
fi

if [ $(validatekey "$key_browser_sso_user_interaction_disabled" "$plist_file") = "Valid" ]; then
    echo "browser_sso_user_interaction_disabled\t\t\t\t\t"$(/usr/libexec/PlistBuddy -c "Print :$key_browser_sso_user_interaction_disabled" $plist_file)
        case $(/usr/libexec/PlistBuddy -c "Print :$key_browser_sso_user_interaction_disabled" $plist_file) in
            "true")
            browser_sso_user_interaction_disabled_flag=1
            ;;
            *)
            ;;
        esac
fi

if [ $(validatekey "$key_disable_explicit_app_prompt" "$plist_file") = "Valid" ]; then
    echo "disable_explicit_app_prompt\t\t\t\t\t\t"$(/usr/libexec/PlistBuddy -c "Print :$key_disable_explicit_app_prompt" $plist_file)
    case $(/usr/libexec/PlistBuddy -c "Print :$key_disable_explicit_app_prompt" $plist_file) in
        "false")
        disable_explicit_app_prompt_flag=1
        ;;
        *)
        ;;
    esac

fi

if [ $(validatekey $key_disable_explicit_app_prompt_and_autologin $plist_file) = "Valid" ]; then
    echo "disable_explicit_app_prompt_and_autologin\t\t\t\t"$(/usr/libexec/PlistBuddy -c "Print :$key_disable_explicit_app_prompt_and_autologin" $plist_file)
    case $(/usr/libexec/PlistBuddy -c "Print :$key_disable_explicit_app_prompt_and_autologin" $plist_file) in
        "false")
        disable_explicit_app_prompt_and_autologin_flag=1
        ;;
        *)
        ;;
    esac

fi

if ((disable_explicit_app_prompt_flag == 1 && disable_explicit_app_prompt_and_autologin_flag == 1)); then
    disable_explicit_app_prompt_overall_flag=1
fi

if /usr/libexec/PlistBuddy -c "Print :$SSOUIPromptDateKey" $plist_file >/dev/null 2>&1 && /usr/libexec/PlistBuddy -c "Print :$bundleIdOfAppShowingUI" $plist_file >/dev/null 2>&1; then
    notesflag=1
    echo "SSOUIPromptDateKey\t\t\t\t\t\t\t"$(/usr/libexec/PlistBuddy -c "Print :$SSOUIPromptDateKey" $plist_file)
    echo "bundleIdOfAppShowingUI\t\t\t\t\t\t\t"$(/usr/libexec/PlistBuddy -c "Print :$bundleIdOfAppShowingUI" $plist_file)
fi

#Pull SSOE logs into memory
logcontent=$(cat $ssoelog_folder/*.log)

appConfig $logcontent "AppPrefixAllowList"
appConfig $logcontent "AppAllowList"
appConfig $logcontent "AppBlockList"

echo 
echo
if ((browser_sso_interaction_enabled_flag == 1 |
     browser_sso_user_interaction_disabled_flag == 1 |
     disable_explict_app_prompt_flag == 1 |
     disable_explict_app_prompt_and_autologin_flag == 1 |
     disable_explict_app_prompt_overall_flag == 1 |
     bundleid_flag == 1
     )); then

     echo "$(tput bold)Recommendations:$(tput sgr0)"
fi
    

if ((browser_sso_interaction_enabled_flag == 1)); then
    echo "$(tput bold)browser_sso_interaction_enabled$(tput sgr0) is set to false and will prevent the SSO extension from acquiring a PRT from the browser and apps that don't support MSAL" 
    echo "Please refer to: https://aka.ms/aadmacssoe#allow-users-to-sign-in-from-applications-that-dont-use-msal-and-the-safari-browser"
    echo
fi


if ((browser_sso_user_interaction_disabled_flag == 1)); then
     echo "$(tput bold)browser_sso_user_interaction_enabled$(tput sgr0) is set to false, which indicates that $(tput bold) Don't ask me to sign in with SSO for this device$(tput sgr0) is enabled in the Company Portal, and will prevent the SSO from acquiring a PRT from the browser."
     echo "We highly recommend that you change (uncheck) this setting in the Company Portal App." 
     echo "For more information: https://aka.ms/macssoecpconfig"
     echo 
fi

if ((disable_explicit_app_prompt_overall_flag == 1)); then
    echo "It appears that both $(tput bold)disable_explicit_app_prompt$(tput sgr0) and $(tput bold)disable_explicit_app_prompt_and_autologin$(tput sgr0) are both disabled."
    echo "The recommended configuration is to enable one of these settings to ensure that the application doesn't break the functionality of the SSO extension. For more details: https://aka.ms/aadmacssoe#apps-that-dont-use-a-microsoft-authentication-library"
    echo
fi

if ((bundleid_flag == 1)); then
    # Check if bundle_ids array is not empty
    if [ ${#bundle_ids[@]} -gt 0 ]; then
        # Print message and the contents of the array
        echo "We have found that the following bundle ids for applications have made an attempt to use the SSO Extension over the past 24 hrs, but the configuration profile from the MDM is blocking them. Please refer to our troubleshooting guidance https://aka.ms/AppleSSOTSG."
        echo "Bundle ID:"
        printf '%s\n' "${bundle_ids[@]}"
    fi
fi

if (($notesflag == 1)); then
    echo "$(tput bold)Note:$(tput sgr0)"
    echo "$(tput bold)SSOUIPromptDateKey$(tput sgr0) shows the datetime that the browser/Non-MSAL application was used to invoke the SSO login prompt."
    echo "This doesn't necessarily mean that the PRT was acquired at this time, but it can be a good indication"
    echo
    echo "$(tput bold)bundleIdOfAppShowingUI$(tput sgr0) shows the bundle id of the browser/Non-MSAL application that invoked the SSO login prompt."
    echo
fi









