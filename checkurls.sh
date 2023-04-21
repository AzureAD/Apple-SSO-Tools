: <<COMMENT
.SYNOPSIS
    macOS AASA URL Connectivity Validator Script Module.

.VERSION
    1.0

.DATE
    21-04-23

.DESCRIPTION
    This script ensures that the Apple App Site Association (AASA) JSON file can be accessed from both Azure AD
    webserver endpoint and Apple's CDN (Content Delivery Network) endpoint when using the Microsoft Enterprise SSO Extension plugin.

    Beginning with macOS version 11 (Big Sur) and later, Apple has changed the behavior of how apps request access to the AASA file.
    Apps now request access from Apple's CDN endpoint instead of directly from the webserver. Apple's CDN requests the AASA file from each
    Associated Domain within 24 hours, and macOS devices check for updates approximately once per week post installation. 

    For example, if the URL: login.microsoftonline.com has been defined in the MDM payload settings then the 
    AASA JSON file should be accessible from each of the following locations:

        1) https://login.microsoftonline.com/.well-known/apple-app-site-association
        2) https://app-site-association.cdn-apple.com/a/v1/login.microsoftonline.com

    The script will issue curl commands to ensure that connectivity checks pass (HTTP RESPONSE of 200 received) for each URL defined in the authsrv URLs defined in
    Microsoft SSO Extension. If a FAILURE is encountered, the script will re-issue a curl command with verbose output. 

    References:
        Microsoft Enterprise SSO Extension Plugin for Apple Devices: https://learn.microsoft.com/en-us/azure/active-directory/develop/apple-sso-plugin
        Microsoft Enterprise SSO Extenson Plugin Troubleshooting Guide: https://learn.microsoft.com/en-us/azure/active-directory/devices/troubleshoot-mac-sso-extension-plugin 
        Supporting Associated Domains: https://developer.apple.com/documentation/xcode/supporting-associated-domains
        Associated Domains Entitlement: https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_associated-domains



.USAGE
    Before running the script the first time, use chmod to add execute permissions:
        chmod +x checkurls.sh 
        chmod +x SSOETroubleshoot.zsh
    To run script:
        ./SSOETroubleshoot.zsh
        Enter "1"    


.AUTHOR:
    Identity Customer Experience Engineeering (CxE) MacOS V-Team

.EXAMPLE OUTPUT
    
    Checking connectivity access for Auth Server URL: login.partner.microsoftonline.cn from macOS Device to Azure AD hosted AASA:VERIFIED
    Checking connectivity access for Auth Server URL: login.partner.microsoftonline.cn from macOS Device to Apple's CDN hosted AASA:VERIFIED
    Checking connectivity access for Auth Server URL: login.microsoftonline.us from macOS Device to Azure AD hosted AASA:VERIFIED
    Checking connectivity access for Auth Server URL: login.microsoftonline.us from macOS Device to Apple's CDN hosted AASA:VERIFIED
    Checking connectivity access for Auth Server URL: login.microsoftonline.de from macOS Device to Azure AD hosted AASA:FAILED
    ***************************************************Curl Verbose Output***************************************************

    *   Trying 51.4.145.173:443...
    * After 994ms connect time, move on!
    * connect to 51.4.145.173 port 443 failed: Operation timed out
    *   Trying 51.4.145.158:443...
    * After 495ms connect time, move on!
    * connect to 51.4.145.158 port 443 failed: Operation timed out
    *   Trying 51.4.145.108:443...
    * After 244ms connect time, move on!
    * connect to 51.4.145.108 port 443 failed: Operation timed out
    *   Trying 51.4.145.169:443...
    * After 120ms connect time, move on!
    * connect to 51.4.145.169 port 443 failed: Operation timed out
    * Failed to connect to login.microsoftonline.de port 443 after 1884 ms: Operation timed out
    * Closing connection 0
    curl: (28) Failed to connect to login.microsoftonline.de port 443 after 1884 ms: Operation timed out
    *************************************************************************************************************************
    Checking connectivity access for Auth Server URL: login.microsoftonline.de from macOS Device to Apple's CDN hosted AASA:FAILED
    ***************************************************Curl Verbose Output***************************************************

    *   Trying 17.253.3.199:443...
    * Connected to app-site-association.cdn-apple.com (17.253.3.199) port 443 (#0)
    * ALPN: offers h2
    * ALPN: offers http/1.1
    *  CAfile: /etc/ssl/cert.pem
    *  CApath: none
    * (304) (OUT), TLS handshake, Client hello (1):
    * (304) (IN), TLS handshake, Server hello (2):
    * (304) (IN), TLS handshake, Unknown (8):
    * (304) (IN), TLS handshake, Certificate (11):
    * (304) (IN), TLS handshake, CERT verify (15):
    * (304) (IN), TLS handshake, Finished (20):
    * (304) (OUT), TLS handshake, Finished (20):
    * SSL connection using TLSv1.3 / AEAD-AES128-GCM-SHA256
    * ALPN: server accepted http/1.1
    * Server certificate:
    *  subject: CN=app-site-association.cdn-apple.com; O=Apple Inc.; ST=California; C=US
    *  start date: Aug  5 18:11:56 2022 GMT
    *  expire date: Sep  4 18:11:55 2023 GMT
    *  subjectAltName: host "app-site-association.cdn-apple.com" matched cert's "app-site-association.cdn-apple.com"
    *  issuer: CN=Apple Public Server ECC CA 12 - G1; O=Apple Inc.; ST=California; C=US
    *  SSL certificate verify ok.
    > GET /a/v1/login.microsoftonline.de HTTP/1.1
    > Host: app-site-association.cdn-apple.com
    > User-Agent: curl/7.85.0
    > Accept: */*
    > 
    * Mark bundle as not supporting multiuse
    < HTTP/1.1 404 Not Found
    < Apple-Failure-Details: {"cause":"context deadline exceeded (Client.Timeout exceeded while awaiting headers)"}
    < Apple-Failure-Reason: SWCERR00301 Timeout
    < Apple-From: https://login.microsoftonline.de/.well-known/apple-app-site-association
    < Apple-Try-Direct: true
    < Cache-Control: max-age=1800,public
    < Content-Length: 10
    < Content-Type: text/plain; charset=utf-8
    < Date: Mon, 16 Jan 2023 17:13:56 GMT
    < Expires: Mon, 16 Jan 2023 17:14:06 GMT
    < Age: 872
    < Via: http/1.1 usqas4-vp-vst-008.ts.apple.com (acdn/176.13298), https/1.1 usqas4-vp-vfe-005.ts.apple.com (acdn/168.13283), http/1.1 usnyc3-edge-lx-011.ts.apple.com (acdn/53.14169), http/1.1 usnyc3-edge-bx-015.ts.apple.com (acdn/53.14169)
    < X-Cache: hit-fresh, hit-stale, hit-fresh, hit-fresh
    < CDNUUID: 7c70c52b-1aa8-4444-b647-230d08ca141d-18036857298
    < Connection: keep-alive
    * The requested URL returned error: 404
    * Closing connection 0
    curl: (22) The requested URL returned error: 404
*************************************************************************************************************************
COMMENT


#Functions
callCURL()
{
    #parameters
    local displayString="$1"
    local urlString="$2"
    
    #variable
    local curlResponse

    echo $displayString'\c';
    curlResponse=$(curl --write-out "%{http_code}" --silent --output /dev/null --connect-timeout 2 $urlString)
    if [ "$curlResponse" != 200 ]
                    then
                        echo "FAILED"
                        echo "***************************************************Curl Verbose Output***************************************************";echo 
                        curl $urlString -v -f --connect-timeout 2;echo "*************************************************************************************************************************"
                    else
                        echo "VERIFIED"
                    fi
}
#Constants

declare -a authsrvurls
declare -a authsrvurlswithoutprefix
strConfigProfileURLs=""

# Debug # authsrvurls=("login.microsoftonline.com" "login.microsoft.com" "sts.windows.net" "login-us.microsoftonline.com" "login.chinacloudapi.cn" "login.partner.microsoftonline.cn" "login.microsoftonline.us") #"login.microsoftonline.de" "login.usgovcloudapi.net")
associatedDomainPath='/.well-known/apple-app-site-association'
httpsPrefix='https://'
appleCDNassociatedDomainPath='app-site-association.cdn-apple.com/a/v1/'
accessString="Checking connectivity access for Auth Server URL: "
macOSString=" from macOS Device to "
appleCDNString="Apple's CDN"
azureadString="Azure AD"
hostedAASAString=" hosted AASA: "
beginBold='\033[1m'
endBold='\033[0m'
displayString=""
urlString=""
# Debug # displayString=$accessString$beginBold$x$endBold$macOSString$beginBold$azureadString$endBold$hostedAASAString
# Debug # displayString=$accessString$beginBold$x$endBold$macOSString$beginBold$appleCDNString$endBold$hostedAASAString

#Extract the authsrvurls from the macOS system profiler

strConfigProfileURLs=$(system_profiler SPConfigurationProfileDataType \
| awk '/ExtensionIdentifier = "com.microsoft.CompanyPortalMac.ssoextension";/{flag=1;next}/}/{flag=0}flag' \
| awk '/URLs =/{flag=1;next}/);/{flag=0}flag' \
| awk '!/)/' \
| awk '{gsub(/^[ \t]+/,"",$0);print}')

while IFS=, read -r -a line; do
	authsrvurls+=("${line[@]}")
done <<< "$strConfigProfileURLs"

#Remove double quotes from elements in array
authsrvurls=("${authsrvurls[@]//\"/}")

#Another array that contains the URLs without the https:// prefix
authsrvurlswithoutprefix=("${authsrvurls[@]//https:\/\/}")


# Debug # echo "$strConfigProfileURLs"
# Debug # echo "${authsrvurls[@]}"
# Debug # echo "${authsrvurlswithoutprefix[@]}"
  j=0 #Initialize counter variable to refernce the authsrvurlswithoutprefix array while interating through the other loop
  for i in "${authsrvurls[@]}"
         do
            #Get URL output string without https:// prefix and store in x variable
            x=${authsrvurlswithoutprefix[$j]}        
    
            #Test each authsrv URL from the macOS device to the Azure AD endpoint where the associated domain records are hosted
            #Example: login.microsoftonline.com --> https://login.microsoftonline.com/.well-known/apple-app-site-association
            #Format the displayString to send to callCurl function
            displayString="$accessString$beginBold$x$endBold$macOSString$beginBold$azureadString$endBold$hostedAASAString";
            urlString="$i$associatedDomainPath";
            # Debug # echo "*********Azure AD Endpoint Check*********"
            # Debug # echo "value for authwithoutprefix0: ${authsrvurlswithoutprefix[0]}"
            # Debug # echo "value for authwithoutprefix1: ${authsrvurlswithoutprefix[1]}"
            # Debug # echo "value for j: $j"
            # Debug # echo "value for x: $x"
            # Debug # echo "value for displayString: $displayString"
            # Debug # echo "value for urlString: $urlString"
            callCURL "$displayString" "$urlString"
            
            #Test each authsrv URL from the macOS device to Apple's CDN endpoint where the associated domain records are hosted
            #Example login.microsoftonline.com --> https://app-site-association.cdn-apple-com/a/v1/login.microsoftonline.com 
            displayString="$accessString$beginBold$x$endBold$macOSString$beginBold$appleCDNString$endBold$hostedAASAString";
            urlString="$httpsPrefix$appleCDNassociatedDomainPath$x";
            callCURL "$displayString" "$urlString";

             ((j++))
       done
###echo "************************************************End of Script*******************************************************"
