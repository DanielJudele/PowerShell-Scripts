<#
.SYNOPSIS
Sets versioning for a SharePoint Online list.
.DESCRIPTION
Sets versioning for a SharePoint Online list. The list is identified by title specified as parameter.
.PARAMETER SharePointSiteUrl
The SharePoint Site Url.
.PARAMETER Username
The Username to access the SharePoint Site.
.PARAMETER Password
The Username to access the SharePoint Site.
.PARAMETER Title
The title of the list for which it's necessary to set the versioning.
.PARAMETER EnableVersioning
True, if the versioning should be enabled, otherwise false.
.PARAMETER EnableMinorVersions
True, if the minor versioning should be enabled, otherwise false.
.PARAMETER MajorWithMinorVersionsLimit
Set the minor version limit (1-50.000). The default value is 511.
.EXAMPLE
Examples:
Set-ListVersioning.ps1 -SharePointSiteUrl <https://<your sharepoint tenant>.sharepoint.com/sites/<your site name> -Username "<your username>" -Password "<your password as secure string>" -Title "<your site title>" -EnableVersioning $false
Set-ListVersioning.ps1 -SharePointSiteUrl <https://<your sharepoint tenant>.sharepoint.com/sites/<your site name> -Username "<your username>" -Password "<your password as secure string>" -Title "<your site title>" -EnableVersioning $true -EnableMinorVersions $true -MajorWithMinorVersionsLimit 511
.NOTES
    Author: Daniel Judele
    Last Edit: 2020-02-25
    Version 1.0 - initial release
.LINK
https://docs.microsoft.com/en-us/previous-versions/office/sharepoint-csom/ee539882(v=office.15)
#>

#Requires -Version 5.0
#Requires -Modules Microsoft.Online.SharePoint.PowerShell

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
    [Parameter(Mandatory=$false)]
    [string] $Title,
    [Parameter(Mandatory=$true)]
    [bool] $EnableVersioning,
    [Parameter(Mandatory=$false)]
    [bool] $EnableMinorVersions,
    [Parameter(Mandatory=$false)]
    [int] $MajorWithMinorVersionsLimit
)

try{
    Write-Output "Connecting to `"$SharePointSiteUrl`"site..."
    $credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Username, $Password)    
    $clientContext = New-Object Microsoft.SharePoint.Client.ClientContext($SharePointSiteUrl)
    $clientContext.Credentials = $credentials

    Write-Output "Getting `"$Title`" list..."    
    $list = $clientContext.Web.Lists.GetByTitle($Title)
    $clientContext.Load($list)    
    $clientContext.ExecuteQuery();

    Write-Output "Setting versioning..."
    $list.EnableVersioning = $EnableVersioning
    if($EnableMinorVersions){
        $list.EnableMinorVersions = $EnableMinorVersions

        if($MajorWithMinorVersionsLimit){
            $list.MajorWithMinorVersionsLimit = $MajorWithMinorVersionsLimit
        }
    }    
    $list.Update()
    $clientContext.ExecuteQuery();
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


