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

# Configure build environment
Set-BuildEnvironment -Force

$ModuleVersion = (Import-PowerShellDataFile -Path $env:BHPSModuleManifest).ModuleVersion

$BuilderEnv = [ordered] @{
    General = @{
        # Root directory for the project
        ProjectRoot = $env:BHProjectPath

        # Root directory for the module
        SrcRootDir = $env:BHPSModulePath

        # The name of the module. This should match the basename of the PSD1 file
        ModuleName = $env:BHProjectName

        # Module version
        ModuleVersion = $moduleVersion

        # Module manifest path
        ModuleManifestPath = $env:BHPSModuleManifest
    }

    Build = @{
        # Output directory for module build
        OutDir = [IO.Path]::Combine($env:BHProjectPath, 'temp', 'output')

        # Directory to write build logs to
        LogDir = [IO.Path]::Combine($env:BHProjectPath, 'temp', 'logs')

        # Directory to save reports to
        ReportDir = [IO.Path]::Combine($env:BHProjectPath, 'temp', 'reports')
    }

    Test = @{

    }

    Help = @{

    }

    Docs = @{

    }

    Publish = @{

    }
}

# Load build tasks from separate module
# https://github.com/nightroman/Invoke-Build/tree/master/Tasks/Import
Import-Module Builder -Force

foreach ($TaskFile in (Get-Command '*.tasks' -Module 'Builder')) {
    . $TaskFile
}

# Establish build properties
Enter-Build {
    $ManifestFile = (Get-PSModuleManifest -Path $BuildRoot)
    $Manifest = Import-PowerShellDataFile -Path $ManifestFile
    $ModuleName = (Get-Item -Path $ManifestFile).BaseName
    $Config = Import-PowerShellDataFile -Path "$BuildRoot\$ConfigurationFile"
    $RegistryUri = "$($Config.RegistryBaseUri)/$($Config.ProjectName)"
    $PackageLogFilePath = "$($Config.LogPath)\publish-gpr.log"

    requires -Variable Manifest, Config
}
