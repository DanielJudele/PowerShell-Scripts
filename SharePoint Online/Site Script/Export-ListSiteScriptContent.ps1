<#
.SYNOPSIS
Exports the content of a site script from a SharePoint tenant.
.DESCRIPTION
Use this script to export the content property of a SharePoint site script to SharePoint tenant. The SharePoint site script is identified based on title parameter.
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
Export-SiteScript.ps1 -AdminSiteUrl <https://<your sharepoint tenant>.sharepoint.com/sites/<your site name> -Username "<your username>" -Password "<your password as secure string>" -Title "Site script tile" -Path "<the file path where the content of the script will be saved>"
Export-SiteScript.ps1 -AdminSiteUrl <https://<your sharepoint tenant>.sharepoint.com/sites/<your site name> -Username "<your username>" -Password "<your password as secure string>" -Title "Site script sample" -Path "C:\temp\samplescriptcontent.json"
.NOTES
    Author: Daniel Judele
    Last Edit: 2020-02-26
    Version 1.0 - initial release
    Version 2.0 - added Common.SharePoint.PowerShell module
.LINK
https://docs.microsoft.com/en-us/powershell/module/sharepoint-online/set-spositescript?view=sharepoint-ps
https://docs.microsoft.com/en-us/powershell/module/sharepoint-online/set-spositescript?view=sharepoint-ps 
#>

#Requires -Version 5.0
#Requires -Modules Microsoft.Online.SharePoint.PowerShell, Common.SharePoint.PowerShell

param(	
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $AdminSiteUrl,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $ListUrl,       
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $Username,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [securestring]$Password,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $Path
)

try{
    $Path = $Path.Trim('"')
    if(!(Test-Path -Path (Split-Path $Path))){
        Throw "The `"$Path `" path is not valid."
    }

    Write-Output "Connecting to `"$AdminSiteUrl`" site..."

    try{
        $cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $Username, $Password
        Connect-SPOService -Url $AdminSiteUrl -Credential $cred
           
    }catch{
        Connect-SPOService -Url $AdminSiteUrl
    }

    Write-Output "Getting site script content from `"$ListUrl`" list..."
    $content = Get-CSPOListSiteScript -ListUrl $ListUrl

    if($content){
        Write-Output "Saving the content of the `"$Title`" site script to `"$Path`" ..."
        $content | Out-File $Path
    }else{
        "Could not get the site script content from `"$SharePointListUrl`" list url."
    }
}catch{
    Write-Error $_.Exception.Message
}
finally{    
    Disconnect-SPOService
    Write-Output "Done"
}