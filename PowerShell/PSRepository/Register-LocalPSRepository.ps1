<#
.SYNOPSIS
Registers a local PowerShell repository folder. 
.DESCRIPTION
Use this script register a local PowerShell repository folder. The path can a local or a shared folder.
Before to run the script, it's necessary to adjust the values for $path and for the name of your repository.
If the path is a shared folder, set the necessary permissions before to run the script.
.PARAMETER PSRepositoryName
The PowerShell repository name.
.PARAMETER Path
The path to a local or a shared folder.
.EXAMPLE
Example:
Register-LocalPSRepository.ps1 -PSRepositoryName "LocalPSRepository" -Path "C:\PowerShellRepository"
.NOTES
    Author: Daniel Judele
    Last Edit: 2020-04-28
    Version 1.0 - initial release
.LINK
https://docs.microsoft.com/en-us/powershell/module/powershellget/register-psrepository?view=powershell-7
#>

#Requires -Version 5.0

param(	
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $PSRepositoryName,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $Path
)

try{
    $parameters = @{
        Name = $PSRepositoryName
        SourceLocation = $Path
        PublishLocation = $Path
        InstallationPolicy = 'Trusted'
    }

    $psRepository =  Get-PSRepository | Where-Object Name -eq $PSRepositoryName

    if($psRepository){
        Throw "The `"$PSRepositoryName`" repository is already registered."
    }

    Register-PSRepository @parameters
    Get-PSRepository $PSRepositoryName
}catch{
    Write-Error $_.Exception.Message
}
finally{ 
    Write-Output "Done"
}