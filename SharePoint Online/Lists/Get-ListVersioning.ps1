<#
.SYNOPSIS
Gets versioning settings for a SharePoint Online list.
.DESCRIPTION
Gets versioning settings for a SharePoint Online list. The list is identified by title specified as parameter.
.PARAMETER SharePointSiteUrl
The SharePoint Site Url.
.PARAMETER Username
The Username to access the SharePoint Site.
.PARAMETER Password
The Username to access the SharePoint Site.
.PARAMETER Title
The title of the list for which it's necessary to get the versioning settings.
Examples:
Get-ListVersioning.ps1 -SharePointSiteUrl <https://<your sharepoint tenant>.sharepoint.com/sites/<your site name> -Username "<your username>" -Password "<your password as secure string>" -Title "<your site title>"
Get-ListVersioning.ps1 -SharePointSiteUrl <https://<your sharepoint tenant>.sharepoint.com/sites/<your site name> -Username "<your username>" -Password "<your password as secure string>" -Title "<your site title>"
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
    [string] $Title
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

    Write-Output "Getting versioning settings..."
    Write-Output "  EnableVersioning: $($list.EnableVersioning)"
    Write-Output "  EnableMinorVersions: $($list.$EnableMinorVersions)"
    Write-Output "  MajorWithMinorVersionsLimit: $($list.$MajorWithMinorVersionsLimit)"
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


