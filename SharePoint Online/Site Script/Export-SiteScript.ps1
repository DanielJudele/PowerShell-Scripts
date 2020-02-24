<#
.SYNOPSIS
Exports the content of a site script from a SharePoint tenant.
.DESCRIPTION
Use this script to export the content of a script to SharePoint tenant. The script is identified using the Title parameter.
.PARAMETER AdminSiteUrl
The Administration(Admin) SharePoint Site Url, <https://<your sharepoint tenant>-admin.sharepoint.com.
.PARAMETER Username
The Username to access the SharePoint Site. The username should be tenant admin.
.PARAMETER Password
The Password to access the SharePoint Site.
.PARAMETER Title
The title of the site script.
.PARAMETER Path
The file path where the content of the script will be saved.
.EXAMPLE
The following example is doing something:
Export-SiteScript.ps1 -AdminSiteUrl <https://<your sharepoint tenant>.sharepoint.com/sites/<your site name> -Username "<your username>" -Password "<your password as secure string>" -Title "Site script tile" -Path "<the file path where the content of the script will be saved>"
Export-SiteScript.ps1 -AdminSiteUrl <https://<your sharepoint tenant>.sharepoint.com/sites/<your site name> -Username "<your username>" -Password "<your password as secure string>" -Title "Site script sample" -Path "C:\temp\samplescriptcontent.json"
.NOTES
    Author: Daniel Judele
    Last Edit: 2020-02-24
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
    [string] $Path
)

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

function Get-SiteScriptWithAllPropertiesByTitle{
    param (
        [Parameter(Mandatory=$true)]
        [string]$Title
    )
    $siteScript = Get-SiteScriptByTitle -Title $Title
    if(!$siteScript){
        "Throw `"$Title`" site script could not be found."
    }

    return (Get-SPOSiteScript $siteScript.Id)

    <#
    .SYNOPSIS
        Gets all details of the site script by title.
    .DESCRIPTION
        The Get-SiteScriptWithAllDetailsByTitle returns all the properties of the site script. The title of the script is used to retrieve the site script from tenant.
    .PARAMETER Title
        The title of the site script.
    #>
}

try{
    $Path = $Path.Trim('"')
    if(!(Test-Path -Path (Split-Path $Path))){
        Throw "The `"$Path `" path is not valid."
    }

    $credentials = New-Object System.Management.Automation.PSCredential($Username, $Password)
    Write-Output "Connecting to `"$AdminSiteUrl`" site..."    
    Connect-SPOService $AdminSiteUrl -Credential $credentials

    Write-Output "Getting `"$Title`" site script..."
    $siteScript = Get-SiteScriptWithAllPropertiesByTitle -Title $Title

    if($siteScript){
        Write-Output "Saving the content of the `"$Title`" site script to `"$Path`" ..."
        (ConvertTo-Json -InputObject $siteScript.Content) | Out-File $Path 
    }else{
        "Throw `"$Title`" site script could not be found."
    }
}catch{
    Write-Error $_.Exception.Message
}
finally{    
    Disconnect-SPOService
    Write-Output "Done"
}