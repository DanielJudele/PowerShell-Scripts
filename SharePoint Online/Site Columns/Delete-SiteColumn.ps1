<#
.SYNOPSIS
Delete a site column from a SharePoint Site Collection.
.DESCRIPTION
Delete a site column from a SharePoint Site Collection to a Comma Separated Values file (.csv).
.PARAMETER SharePointSiteUrl
The SharePoint Site Collection Url.
.PARAMETER Username
The Username to access the SharePoint Site.
.PARAMETER Password
The Username to access the SharePoint Site.
.EXAMPLE
The following example is doing something:
Delete-SiteColumn.ps1 -SharePointSiteUrl <https://<your sharepoint tenant>.sharepoint.com/sites/<your site name> -Username "<your username>" -Password "<your password as secure string>" -Name "<your Site column Name>" 
.NOTES
    Author: Daniel Judele
    Last Edit: 2020-02-18
    Version 1.0 - initial release
.LINK
https://docs.microsoft.com/en-us/previous-versions/office/sharepoint-csom/ee544713(v%3Doffice.15)
https://docs.microsoft.com/en-us/powershell/scripting/developer/module/how-to-write-a-powershell-script-module?view=powershell-7 
#>

#Requires -Version 5.0
#Requires -Modules Microsoft.Online.SharePoint.PowerShell, SharePointPnPPowerShellOnline

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
	[string] $Name
)

# function Get-SPOContext {
#     [cmdletbinding(DefaultParameterSetName='ClassicAuthentication')]
#     param (        
#         [Parameter(ParameterSetName = 'ClassicAuthentication',Mandatory=$true, Position = 0)]
#         [Parameter(ParameterSetName = 'MultiFactorAuthentication', Mandatory=$true,Position = 0)]
#         [Parameter(Mandatory=$true,Position = 0)]
#         [ValidateNotNullOrEmpty()]
#         [string] $SharePointSiteUrl,

#         [Parameter(ParameterSetName="ClassicAuthentication", Mandatory=$true,Position = 1)]
#         [ValidateNotNullOrEmpty()]
#         [string] $Username,
#         [Parameter(ParameterSetName="ClassicAuthentication", Mandatory=$true, Position = 2)]
#         [ValidateNotNullOrEmpty()]
#         [System.Security.SecureString] $Password,

#         [Parameter(ParameterSetName="MultiFactorAuthentication", Mandatory=$true,Position = 1)]
#         [ValidateNotNullOrEmpty()]
#         [bool] $UseMFA
#     )

#     $clientContext = $null
#     switch ($PsCmdlet.ParameterSetName)
#         {
#             "ClassicAuthentication" {
#                 Write-Output "Connecting to `"$SharePointSiteUrl`"site using username and password..."
#                 $credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Username, $Password)    
#                 $clientContext = New-Object Microsoft.SharePoint.Client.ClientContext($SharePointSiteUrl)
#                 $clientContext.Credentials = $credentials
#                 $clientContext.ExecuteQuery();
#                 break
#             }
#             "MultiFactorAuthentication" {
#                 Connect-PnPOnline -Url $SharePointSiteUrl -UseWebLogin
#                 $clientContext = Get-PnPContext
#                 $clientContext.ExecuteQuery();
#                 break
#             }
#         }

#     return $clientContext

#     <#
#     .SYNOPSIS
#         Gets the site script by title.
#     .DESCRIPTION
#         The Get-SiteScriptByTitle is trying to find the site script using the title.
#     .PARAMETER Title
#         The title of the site script.
#     #>
# }

try{
    Write-Output "Connecting to `"$SharePointSiteUrl`"site..."
    try{
        $clientContext = Get-SPOContext -SharePointSiteUrl $SharePointSiteUrl -Username $Username -Password $Password    
    }catch{
        Connect-PnPOnline -Url $SharePointSiteUrl -UseWebLogin
        $clientContext = Get-PnPContext
    }

    $clientContext.Load($clientContext.Web)
    $clientContext.ExecuteQuery();
    
    Write-Output "Getting site columns..."
    $fields = $clientContext.Web.Fields
    $clientContext.Load($fields)    
    $clientContext.ExecuteQuery();
    
    $siteColumn = $fields.GetByTitle($Name)
    $clientContext.Load($siteColumn)    
    $clientContext.ExecuteQuery();
    
    if(!$siteColumn){
        Throw "`"$Name`" site column was not found."
    }
    
    $siteColumn.DeleteObject()
    $clientContext.ExecuteQuery()
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