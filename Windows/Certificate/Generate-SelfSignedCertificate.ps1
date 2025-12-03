<#
.SYNOPSIS
Creates and export self-signed certificate.
.DESCRIPTION
Use this script to generate and export self-signed certificate and export certificate.
.PARAMETER Name
The name of the certificate.
.PARAMETER Password
The Password used to generate pfx certificate.
.PARAMETER CertStoreLocation
The location to store the certificate before to export it.
.PARAMETER ExportFolder
The folder path where the certificate should be exported.
.EXAMPLE
Generate-SelfSignedCertificate.ps1 -Name "<your certificate name>" -Password "<your password as secure string>" -CertStoreLocation "Cert:\CurrentUser\My" -ExportFolder "<C:\temp>"
.NOTES
    Author: Daniel Judele
    Last Edit: 2025-12-04
    Version 1.0 - initial release
.LINK
https://learn.microsoft.com/en-us/powershell/module/pki/export-certificate?view=windowsserver2025-ps
#>

#Requires -Modules PKI

param(	
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $Name,

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [securestring] $Password,

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $CertStoreLocation,

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $ExportFolder
)

try{
    $ExportFolder = $ExportFolder.Trim('"')
    if(!(Test-Path -Path (Split-Path $ExportFolder))){
        Throw "The `"$ExportFolder `" path is not valid."
    }

    $cert = New-SelfSignedCertificate -Subject "CN=$Name" -CertStoreLocation $CertStoreLocation -KeyExportPolicy Exportable

    $fullPath = Join-Path $ExportFolder "$Name.cer"
    Export-Certificate -Cert $cert -FilePath $fullPath

    $fullPath = Join-Path $ExportFolder "$Name.pfx"
    Export-PfxCertificate -Cert $cert -FilePath $fullPath -Password $Password
}catch{
    Write-Error $_.Exception.Message
}
finally{
    Write-Output "Done"
}