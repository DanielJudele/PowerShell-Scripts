<#
.SYNOPSIS
<A brief description of the script>
.DESCRIPTION
<A detailed description of the script>
.PARAMETER ParameterName1
<The description of the ParameterName1.>
.PARAMETER ParameterName2
<The description of the ParameterName2.>
.EXAMPLE
The following example is doing something:
Template.ps1 -ParameterName1
.NOTES
    Author: The name of the author.
    Last Edit: yyyy-mm-dd
    Version 1.0 - initial release
    Version 1.1 - fix bugs
.LINK
https://docs.microsoft.com/en-us/powershell/scripting/overview
https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7
https://github.com/powershell/powershell 
.INPUTS
The description of the input objects (Microsoft .NET Framework types of objects) that can be piped to the script.
.OUTPUTS
The description of the output objects (Microsoft .NET Framework types of objects) returned from the script
#>

<#
# Specify the path to the assembly DLL file or a .NET assembly name.
# Syntax: #Requires -Assembly { <Path to .dll> | <.NET assembly specification> }
# For example:
#Requires -Assembly path\to\HellowWorld.dll
#Requires -Assembly "System.IO, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"

#Specifies the minimum version of PowerShell that the script requires. Enter a major version number and optional minor version number.For example 
# Syntax: #Requires -Version <N>[.<n>]
# For example:
#Requires -Version 4.0

#Specify a PowerShell snap-in that the script requires. Version number is optional.
# Syntax: #Requires -PSSnapin <PSSnapin-Name> [-Version <N>[.<n>]]
# For example: 
#Requires -PSSnapin Microsoft.PowerShell.Core

#Specifies PowerShell modules that the script requires. Version number is optional.
# Syntax: #Requires -Modules { <Module-Name> | <Hashtable> }
# For example: 
#Requires -Modules Microsoft.PowerShell.Utility,PSScriptAnalyzer
#Requires -Modules @{ModuleName = "Microsoft.PowerShell.Utility"; ModuleVersion="0.12.0"}

#Specifies a PowerShell edition that the script requires. Valid values are Core for PowerShell Core and Desktop for Windows PowerShell.
# Syntax: #Requires -PSEdition <PSEdition-Name>
# For example: 
#Requires -PSEdition Core

#Specifies the shell that the script requires. You can find the current ShellId by querying the $ShellId automatic variable.
# Syntax: #Requires -ShellId <ShellId> -PSSnapin <PSSnapin-Name> [-Version <N>[.<n>]]
# For example:
#Requires -ShellId MyLocalShell -PSSnapin Microsoft.PowerShell.Core

# Specifies that the PowerShell session in which you're running the script must be started with elevated user rights
# Syntax: #Requires -RunAsAdministrator
# For example:
    #Requires -RunAsAdministrator
#>

param(	
    [Parameter(Mandatory=$true)]
    [string] $FolderPath = 'C:\Sources\folder1'
)

function New-Folder(){   
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$FolderPath = 'C:\Sources\folder1'
       
    )

    Write-Output $FolderPath
    if(-not(Test-Path -Path $FolderPath)){
        New-Item -Path $FolderPath -ItemType directory
    }


    <#
    .SYNOPSIS
        Sends the specified objects to the next command in the pipeline. If the command is the last command in the pipeline, the objects are displayed in the console.

    .DESCRIPTION
        The Show-Message sends the specified objects to the next command in the pipeline. 
        If the command is the last command in the pipeline, the objects are displayed in the console.

    .PARAMETER Message
        Specifies the message.
    #>
}

try{
    New-Folder -FolderPath $FolderPath 
    # Get-Help .\Template.ps1
    # Get-Help FunctionSample1
}catch{
    Write-Error $_.Exception.Message
}
finally{
    # Here you can release any allocated resources.
}
    

# Add below the signature, if it's necessary. The signature should be at the end of the script.