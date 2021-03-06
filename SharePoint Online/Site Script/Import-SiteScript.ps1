<#
.SYNOPSIS
Imports a site script to SharePoint tenant.
.DESCRIPTION
Use this script to add or update a script to SharePoint tenant. If the site script content is updated if is found by title, otherwise it will be added.
.PARAMETER AdminSiteUrl
The Administration(Admin) SharePoint Site Url, <https://<your sharepoint tenant>-admin.sharepoint.com.
.PARAMETER Username
The Username to access the SharePoint Site. The username should be tenant admin.
.PARAMETER Password
The Password to access the SharePoint Site.
.PARAMETER Path
The file path which contains the properties of the site script.
.EXAMPLE
The following example is doing something:
Import-SiteScript.ps1 -AdminSiteUrl <https://<your sharepoint tenant>.sharepoint.com/sites/<your site name> -Username "<your username>" -Password "<your password as secure string>" -Title "Site script tile " -Path "<the file path where is the content of the script" -Description "<the description of the script>" -Version "<Version of the script>"
Import-SiteScript.ps1 -AdminSiteUrl <https://<your sharepoint tenant>.sharepoint.com/sites/<your site name> -Username "<your username>" -Password "<your password as secure string>" -Title "Site script samples" -Path "C:\temp\sample.json" -Description "Site Script description" -Version "2.0"
.NOTES
    Author: Daniel Judele
    Last Edit: 2020-02-20
    Version 1.0 - initial release
.LINK
https://docs.microsoft.com/en-us/powershell/module/sharepoint-online/set-spositescript?view=sharepoint-ps
https://docs.microsoft.com/en-us/powershell/module/sharepoint-online/set-spositescript?view=sharepoint-ps 
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
    [securestring]$Password,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $Title,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $Path,
    [Parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [string] $Description,
    [Parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [string] $Version
)

function Add-SiteScript {
	param (
        [Parameter(Mandatory=$true)]
        [string]$Title,
        [Parameter(Mandatory=$true)]
        [string]$Path,
        [Parameter(Mandatory=$false)]
        [string]$Description,
        [Parameter(Mandatory=$false)]
        [string]$Version
    )

    $arguments = @{} + $PSBoundParameters

    $content = Get-Content -Path $Path -Raw
    $arguments.Add("Content", $content)
    $arguments.Remove("Path")

    if([string]::IsNullOrWhiteSpace($Description)){
        $arguments.Remove("Description")
    }

    if([string]::IsNullOrWhiteSpace($Version)){
        $arguments.Remove("Version")
    }

    Add-SPOSiteScript @arguments | Out-Null

    <#
    .SYNOPSIS
        Adds the site script to the tenant.
    .DESCRIPTION
        The Add-SiteScript adds the site script to the tenant.
    .PARAMETER Title
        The title of the site script.
    .PARAMETER Path
        The file path which contains the content of the site script.
    .PARAMETER Description
        The description of the site script.
    .PARAMETER Version
        The version of the site script.
    #>
}
function Get-SiteScriptByTitle{
    param (
        [Parameter(Mandatory=$true)]
        [string]$Title
    )
    
    return (Get-SPOSiteScript | Where-Object {$_.Title -eq $Title})

    <#
    .SYNOPSIS
        Gets the site script by title.
    .DESCRIPTION
        The Get-SiteScriptByTitle is trying to find the site script using the title.
    .PARAMETER Title
        The title of the site script.
    #>
}

function Set-SiteScript {
	param (
        [Parameter(Mandatory=$true)]
        [string]$Title,
        [Parameter(Mandatory=$true)]
        [string]$Id,
        [Parameter(Mandatory=$true)]
        [string]$Path,
        [Parameter(Mandatory=$false)]
        [string]$Description,
        [Parameter(Mandatory=$false)]
        [string]$Version        
    )
    
    $arguments = @{} + $PSBoundParameters

    $content = Get-Content -Path $Path -Raw
    $arguments.Add("Content", $content)
    $arguments.Remove("Path")

    if([string]::IsNullOrWhiteSpace($Description)){
        $arguments.Remove("Description")
    }

    if([string]::IsNullOrWhiteSpace($Version)){
        $arguments.Remove("Version")
    }

    Set-SPOSiteScript @arguments | Out-Null

    <#
    .SYNOPSIS
        Updates the site script to the tenant.
    .DESCRIPTION
        The Set-SiteScript updates the site script to the tenant.
    .PARAMETER Id
        The id(identity) of the site script.
    .PARAMETER Title
        The title of the site script.
    .PARAMETER Path
        The file path which contains the content of the site script.
    .PARAMETER Description
        The description of the site script.
    .PARAMETER Version
        The version of the site script.
    #>
}

try{

    $Path = $Path.Trim('"')
    if(!(Test-Path -Path $Path)){
        Throw "The `"$Path `" path is not valid."
    }

    $credentials = New-Object System.Management.Automation.PSCredential($Username, $Password)
    Write-Output "Connecting to `"$AdminSiteUrl`" site..."    
    Connect-SPOService $AdminSiteUrl -Credential $credentials

    Write-Output "Getting `"$Title`" site script..."
    $siteScript = Get-CSPOSiteScriptByTitle -Title $Title

    if($siteScript){
        Write-Output "Updating`"$Title`" site script..."
        Set-SiteScript -Id $siteScript.Id -Title $Title -Path $Path -Description $Description -Version $Version
    }else{
        Write-Output "Adding`"$Title`" site script..."
        Add-SiteScript -Title $Title -Path $Path -Description $Description -Version $Version
    }
}catch{
    Write-Error $_.Exception.Message
}
finally{    
    Disconnect-SPOService
    Write-Output "Done"
}