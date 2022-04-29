#requires -modules InvokeBuild, BuildHelpers

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

        OrgRepo = @{
            Name = 'Org'
            SourceUri = $env:BUILDER_ORG_REGISTRY_SOURCE_URI
            PublishUri = $env:BUILDER_ORG_REGISTRY_PUBLISH_URI
            SearchUri = $env:BUILDER_ORG_REGISTRY_SEARCH_URI
            ApiKey = $env:BUILDER_ORG_REGISTRY_API_KEY
        }
    }
}

# Load build tasks from separate module
# https://github.com/nightroman/Invoke-Build/tree/master/Tasks/Import
Import-Module Builder -Force

foreach ($TaskFile in (Get-Command '*.tasks' -Module 'Builder')) {
    . $TaskFile
}
