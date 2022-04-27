#requires -modules InvokeBuild, BuildHelpers

<#
.SYNOPSIS
    Executes build tasks within a workspace.

.DESCRIPTION
    A portable collection of build tasks, executed by `Invoke-Build ...` within the project root. Tasks are
    executed using the InvokeBuild module, see: https://github.com/nightroman/Invoke-Build.


.EXAMPLE
    Invoke-Build -ConfigurationFile ./Configuration.psd1

    Executes a build process, using the project configuration file.
#>
param (
    [ValidateScript({ Test-Path $_ })]
    $ConfigurationFile = './Configuration.psd1'
)

Set-StrictMode -Version Latest

# Load build elements from partial files
. "$PSScriptRoot\.build\helpers\Import-BuildPartial.ps1"

$null = Import-BuildPartial -Path "$BuildRoot\.build\helpers"
$null = Import-BuildPartial -Path "$BuildRoot\.build\tasks" -Suffix '*.tasks.ps1'

# Establish build properties
Enter-Build {
    $ManifestFile = (Get-PSModuleManifest -Path $BuildRoot)
    $Manifest = Import-PowerShellDataFile -Path $ManifestFile
    $ModuleName = (Get-Item -Path $ManifestFile).BaseName
    $Config = Import-PowerShellDataFile -Path $ConfigurationFile

    requires -Variable Manifest, Config
}

task . Build
