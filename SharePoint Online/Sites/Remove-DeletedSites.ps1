<#
.SYNOPSIS
Exports site columns from a SharePoint Site Collection.
.DESCRIPTION
Exports site columns from a SharePoint Site Collection to a Comma Separated Values file (.csv).
.PARAMETER AdminSiteUrl
The SharePoint Administration Site Url.
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

<#
.SYNOPSIS
Permanently removes deleted sites from SharePoint Admin Recycle Bin Site based on the url specified in an Comma Separated Values file.
.DESCRIPTION
Permanently removes deleted sites from SharePoint Admin Recycle Bin Site based on the url specified in an Comma Separated Values file.
.PARAMETER AdminSiteUrl
The SharePoint Administration Site Url.
.PARAMETER Username
The Username to access the SharePoint Site.
.PARAMETER Password
The Password to access the SharePoint Site.
.PARAMETER Path
The path of the csv file.
.EXAMPLE
Remove-DeletedSites.ps1 -AdminSiteUrl <https://<your sharepoint tenant>-admin.sharepoint.com> -Username "<your username>" -Password "<your password as secure string>" -Path "<your csv file path>"
.NOTES
    Author: Daniel Judele
    Last Edit: 2020-04-29
    Version 1.0 - initial release
.LINK
#>

#Requires -Version 5.0
#Requires -Modules Microsoft.Online.SharePoint.PowerShell

param(	
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $AdminSiteUrl,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $Username,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [System.Security.SecureString] $Password,    
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [System.Security.SecureString] $Path
)

try{
    Write-Output "Connecting to `"$AdminSiteUrl`" site..."
    
    $sites = Import-Csv -Path $Path

    try{
        $credentials = New-Object System.Management.Automation.PSCredential($Username, $Password)    
        Connect-SPOService $AdminSiteUrl -Credential $credentials
           
    }catch{
        Write-Error $_.Exception.Message
        Connect-SPOService -Url $AdminSiteUrl
    }

    foreach($site in $sites){
        Remove-SPODeletedSite -Identity $site.Url -NoWait -Confirm:$false
    }
}catch{
    Write-Error $_.Exception.Message
}
finally{
    Disconnect-SPOService
    Write-Output "Done"
}
