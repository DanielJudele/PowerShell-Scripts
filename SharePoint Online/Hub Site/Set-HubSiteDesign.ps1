<#
.SYNOPSIS
Sets to hub site a site design.
.DESCRIPTION
Use this script to set the site design for a hub site. The site design is identified based on the title specified as parameter.
.PARAMETER AdminSiteUrl
The Administration(Admin) SharePoint Site Url, <https://<your sharepoint tenant>-admin.sharepoint.com.
.PARAMETER HubSiteUrl
The Hub Site Url, <https://<your sharepoint tenant>.sharepoint.com/sites/<your hub site name>.
.PARAMETER Username
The Username to access the SharePoint Site. The username should be tenant admin.
.PARAMETER Password
The Password to access the SharePoint Site.
.PARAMETER Title
The title of the site design. The site design should be already available on SharePoint tenant.
.EXAMPLE
The following example is doing something:
Set-HubSiteDesign.ps1 -AdminSiteUrl <https://<your sharepoint tenant>.sharepoint.com/sites/<your site name> -HubSiteUrl <https://<your sharepoint tenant>.sharepoint.com/sites/<your hub site name> -Username "<your username>" -Password "<your password as secure string>" -Title "Site design title"
.NOTES
    Author: Daniel Judele
    Last Edit: 2020-02-19
    Version 1.0 - initial release
.LINK
https://docs.microsoft.com/en-us/powershell/module/sharepoint-online/set-spohubsite?view=sharepoint-ps
#>

#Requires -Version 5.0
#Requires -Modules Microsoft.Online.SharePoint.PowerShell

param(	
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $AdminSiteUrl,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $HubSiteUrl,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $Username,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [System.Security.SecureString] $Password,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
	[string] $Title
)

try{
    Write-Output "Connecting to `"$AdminSiteUrl`" site..."
    $credentials = New-Object System.Management.Automation.PSCredential($Username, $Password)    
    Connect-SPOService $AdminSiteUrl -Credential $credentials

    Write-Output "Getting `"$Title`" site design..."
    $siteDesign = Get-SPOSiteDesign | Where-Object {$_.Title -eq $Title}

    if($siteDesign.Id){
        Set-SPOHubSite $HubSiteUrl -SiteDesignId $siteDesign.Id 
    }else{
        Throw "The `"$Title`" site design could not be found."
    }
}catch{
    Write-Error $_.Exception.Message
}
finally{    
    Disconnect-SPOService
    Write-Output "Done"
}