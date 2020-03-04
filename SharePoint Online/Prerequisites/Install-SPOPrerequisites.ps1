<#
.SYNOPSIS
Installs prequisites for SharePoint Online scripts.
.DESCRIPTION
Installs prequisites for SharePoint Online scripts.
.PARAMETER Force
Overrides warning messages about installation conflicts.
.EXAMPLE
Install-SPOPrerequisites.ps1
Install-SPOPrerequisites.ps1 -Force $true
.NOTES
    Author: Daniel Judele
    Last Edit: 2020-03-04
    Version 1.0 - initial release
.LINK
https://docs.microsoft.com/en-us/powershell/sharepoint/sharepoint-online/connect-sharepoint-online?view=sharepoint-ps
#>

param(	
    [Parameter(Position=0, Mandatory=$false)]    
    [bool] $Force = $false
)

try{
    if ($Force -or (!(Get-Module -Name Microsoft.Online.SharePoint.PowerShell -ListAvailable))) {
        if($Force){
            Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Force -Confirm
        }else{
            Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Confirm
        }
    }

    if ($Force -or (!(Get-Module -Name SharePointPnPPowerShellOnline -ListAvailable))) {
        if($Force){
            Install-Module -Name SharePointPnPPowerShellOnline -Force -Confirm
        }else{
            Install-Module -Name SharePointPnPPowerShellOnline  -Confirm
        }
    }    
}catch{
    Write-Error $_.Exception.Message
}
finally{
    Write-Output "Done"
}