<#
.SYNOPSIS
Publish a PowerShell to a local PowerShell repository. 
.DESCRIPTION
Use this script to publish a PowerShell module to a local PowerShell repository folder.
To publish the module to a local repository folder it's necessary to have the PowerShellGet module installed.
.PARAMETER Name
The name of PowerShell module.
.PARAMETER PSRepositoryName
The name of the PowerShell repository.
.EXAMPLE
Example:
Publish-LocalModule.ps1 -Name "SamplePowerShellModule" -PSRepositoryName "MyLocalPSRepository"
.NOTES
    Author: Daniel Judele
    Last Edit: 2020-04-28
    Version 1.0 - initial release
.LINK
https://docs.microsoft.com/en-us/powershell/module/powershellget/publish-module?view=powershell-7
#>

#Requires -Version 5.0
#Requires -Modules PowerShellGet

param(	
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $Name,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $PSRepositoryName
)

try{
    Publish-Module -Name $Name -Repository $PSRepositoryName -Verbose 
}catch{
    Write-Error $_.Exception.Message
}
finally{ 
    Write-Output "Done"
}