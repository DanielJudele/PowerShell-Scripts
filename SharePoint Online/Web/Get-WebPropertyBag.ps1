<#
.SYNOPSIS
Gets the value of a property bag.
.DESCRIPTION
Gets the value of a property bag. The propertybag is identified by name specified as parameter.
.PARAMETER SharePointSiteUrl
The SharePoint Site Url.
.PARAMETER Username
The Username to access the SharePoint Site.
.PARAMETER Password
The Password to access the SharePoint Site.
.PARAMETER Key
The Propery bag name.
Examples:
Get-WebPropertyBag.ps1 -SharePointSiteUrl <https://<your sharepoint tenant>.sharepoint.com/sites/<your site name> -Username "<your username>" -Password "<your password as secure string>" -Key "<your property bag name>"
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
    [securestring] $Password,
    [Parameter(Mandatory=$false)]
    [string] $Key
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

    if(-not $propertyBags.FieldValues.ContainsKey($Key)){
        Throw "The `"$Key`" property bag doesn't exists!"
    }

    $propertyBagValue = $propertyBags[$Key]
    Write-Host "{$Key} : $propertyBagValue"
    
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