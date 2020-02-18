<#
.SYNOPSIS
Exports site columns from a SharePoint Site Collection.
.DESCRIPTION
Exports site columns from a SharePoint Site Collection to a Comma Separated Values file (.csv).
.PARAMETER SharePointSiteUrl
The SharePoint Site Collection Url.
.PARAMETER Username
The Username to access the SharePoint Site.
.PARAMETER Password
The Username to access the SharePoint Site.
.EXAMPLE
The following example is doing something:
Export-SiteCollumns.ps1 -SharePointSiteUrl <https://<your sharepoint tenant>.sharepoint.com/sites/<your site name> -Username "<your username>" -Password "<your password as secure string>" 
.NOTES
    Author: Daniel Judele
    Last Edit: 2020-02-18
    Version 1.0 - initial release
.LINK
https://docs.microsoft.com/en-us/previous-versions/office/sharepoint-csom/ee544713(v%3Doffice.15)
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
	[string] $FilePath
)

try{
    Write-Output "Connecting to `"$SharePointSiteUrl`"site..."
    $credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Username, $Password)    
    $clientContext = New-Object Microsoft.SharePoint.Client.ClientContext($SharePointSiteUrl)
    $clientContext.Credentials = $credentials

    Write-Output "Getting site columns..."    
    $fields = $clientContext.Web.Fields
    $clientContext.Load($fields)    
    $clientContext.ExecuteQuery();

    $path = $FilePath
    if([string]::IsNullOrWhitespace($FilePath)){
        $path = Join-Path -Path $PSScriptRoot -ChildPath "sitecolumns.csv"
    }

    Write-Output "Exporting site columns to `"$path`"..."
    $fields | Export-Csv $path
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


