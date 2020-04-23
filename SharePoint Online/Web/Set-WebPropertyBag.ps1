<#
.SYNOPSIS
Sets the value of a property bag.
.DESCRIPTION
Sets the value of a property bag. The propertybag is identified by name specified as parameter.
.PARAMETER SharePointSiteUrl
The SharePoint Site Url.
.PARAMETER Username
The Username to access the SharePoint Site.
.PARAMETER Password
The Password to access the SharePoint Site.
.PARAMETER Key
The Propery bag name.
.PARAMETER Value
The Propery bag value.
Examples:
Set-WebPropertyBag.ps1 -SharePointSiteUrl <https://<your sharepoint tenant>.sharepoint.com/sites/<your site name> -Username "<your username>" -Password "<your password as secure string>" -Key "<your propertybag name>" -Value "<your propertybag value>" "
.NOTES
    Author: Daniel Judele
    Last Edit: 2020-04-23
    Version 1.0 - initial release
.LINK
https://docs.microsoft.com/en-us/previous-versions/office/sharepoint-server/ee544961(v%3Doffice.15)
#>

#Requires -Version 5.0
#Requires -Modules Common.SharePoint.PowerShell

param(	
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $SharePointSiteUrl,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $Username,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [System.Security.SecureString] $Password,
    [Parameter(Mandatory=$true)]
    [string] $Key,
    [Parameter(Mandatory=$true)]
    [string] $Value
)

try{
    Write-Output "Connecting to `"$SharePointSiteUrl`"site..."
    $clientContext = Get-CSPOSiteContext -SiteUrl $SharePointSiteUrl -Username $Username -Password $Password

    Write-Output "Getting `"$Key`" property bag..."
    $rootWeb = $clientContext.Site.RootWeb
    $propertyBags = $clientContext.Site.RootWeb.AllProperties
    $clientContext.Load($rootWeb)
    $clientContext.Load($propertyBags)
    $clientContext.ExecuteQuery()

    $propertyBags[$Key] = $Value
    $rootWeb.Update()
    
    $clientContext.ExecuteQuery()

    Write-Host "$Key : $Value"
    
}catch{
    Write-Error $_.Exception.Message
}
finally{
    if($clientContext){
        Write-Output "Disposing client context..."
        $clientContext.Dispose()
    }

    Write-Output "Done"
}