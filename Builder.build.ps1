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

$ManifestFile = (Get-PSModuleManifest -Path $BuildRoot)
$Manifest = Import-PowerShellDataFile -Path $ManifestFile
$Config = Import-PowerShellDataFile -Path $ConfigurationFile

requires -Variable Manifest, Config

# Synopsis: Purge files from temp directories
task Clean {
    'build', 'files', 'logs' | ForEach-Object { remove "$BuildRoot\temp\$_\*" }
}

# Synopsis: Execute Build tasks (avoiding setup if possible)
task Build {

}

# Synopsis: Display directory structure
task Structure {
    exec { tree /f /a }
}

# Synopsis: Display environment configuration data
task Environment {
    Write-Build Magenta ($Manifest | ConvertTo-Json)
    Write-Build Cyan ($Config | ConvertTo-Json)
}

# Synopsis: Watch build logs
task Logs {

}

task Show Structure, Environment, Logs

task . Build
