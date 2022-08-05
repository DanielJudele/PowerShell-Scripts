function Unblock-AllFiles(){
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        $Folder
    )

    Get-ChildItem -Path $Folder -Recurse | Unblock-File
    <#
    .SYNOPSIS
        Unblock files that were downloaded from the internet.

    .DESCRIPTION
        The files downloaded from the internet are blocked by default.

    .PARAMETER Folder
        Specifies the folder.
    #>
}
