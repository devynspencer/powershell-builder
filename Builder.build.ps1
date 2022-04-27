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

$BuildHelpers = Import-BuildPartial -Path "$BuildRoot\.build\helpers"
$BuildTasks = Import-BuildPartial -Path "$BuildRoot\.build\tasks" -Suffix '*.tasks.ps1'

# Establish build properties
Enter-Build {
    $ManifestFile = (Get-PSModuleManifest -Path $BuildRoot)
    $Manifest = Import-PowerShellDataFile -Path $ManifestFile
    $ModuleName = (Get-Item -Path $ManifestFile).BaseName
    $Config = Import-PowerShellDataFile -Path $ConfigurationFile

    requires -Variable Manifest, Config
}

$CredentialParams = @{
    TypeName = 'System.Management.Automation.PSCredential'
    ArgumentList = $Config.RegistryUser, (ConvertTo-SecureString -AsPlainText $Config.RegistryToken -Force)
}

$RegistryCredential = New-Object @CredentialParams

# Synopsis: Purge files from temp directories
task Clean {
    'build', 'files', 'logs' | ForEach-Object { remove "$BuildRoot\temp\$_\*" }
}

# Synopsis: Unregister repositories and package sources
task Unregister {
    Write-Build Cyan 'Unregistering PowerShellGet repositories and package sources ...'

    foreach ($Registered in @($Config.RepositoryName, $Config.StagingRepositoryName)) {
        Unregister-PSRepository -Name $Registered -ErrorAction 0 | Out-Null
        Unregister-PackageSource -Source $Registered -ErrorAction 0 | Out-Null
    }
}

# Synopsis: Register repositories and package sources
task Register Unregister, {
    # Staging locally allows non-standard attributes to be added to the nuspec,
    # and is currently necessary to publish to GitHub Packages
    # - See @cdhunt's response here: https://github.com/PowerShell/PowerShellGet/issues/163

    Write-Build Cyan 'Registering PowerShellGet repositories and package sources ...'

    $StagingParams = @{
        Name = $Config.StagingRepositoryName
        SourceLocation = $Config.StagingPath
    }

    Register-PSRepository @StagingParams -InstallationPolicy 'Trusted'

    $RegistryParams = @{
        Name = $Config.RepositoryName
        SourceLocation = $Config.RegistryIndexUri
        PublishLocation = $Config.RegistryBaseUri
        Credential = $RegistryCredential
    }

    Register-PSRepository @RegistryParams -InstallationPolicy 'Trusted'
}

# Synopsis: Install any missing project module dependencies
task Modules {
    $Config.ProjectModules.foreach({ Install-Module @_ })

    Install-Package NuGet
}

# Synopsis: Remove and reinstall all project module dependencies
task Reinstall {
    $Config.ProjectModules.foreach({ Uninstall-Module @_ })
}, Modules

# Synopsis: Publish module to local staging repository
task Package Clean, {
    $script:PackagePath = Join-Path -Path $BuildRoot -ChildPath $Config.StagingPath
    $script:PackageFileName = @($ModuleName, $Manifest.ModuleVersion, 'nupkg') -join '.'

    # Staging locally allows non-standard attributes to be added to the nuspec,
    # and is currently necessary to publish to GitHub Packages
    # - See @cdhunt's response here: https://github.com/PowerShell/PowerShellGet/issues/163
    $PublishParams = @{
        Repository = $Config.StagingRepositoryName
        Path = "$BuildRoot\$($ModuleName)"
        NuGetApiKey = $Config.RegistryToken
    }

    Publish-Module @PublishParams
    Write-Build Cyan "Building package [$PackageFileName] in [$($Config.StagingPath)]"
}

# Synopsis: Perform all publishing tasks
task Publish Package, {
    $script:RegistryUri = "$($Config.RegistryBaseUri)\$($Config.ProjectName)"
    Write-Build Cyan "Deploying package to [$RegistryUri]"

    $PushParams = @{
        FilePath = 'gpr.exe'
        ArgumentList = @(
            'push',
            '--api-key',
            $Config.RegistryToken,
            '--repository',
            $RegistryUri,
            (Join-Path -Path $PackagePath -ChildPath $PackageFileName)
        )
    }

    Start-Process @PushParams -Wait -NoNewWindow -WorkingDirectory $Config.StagingPath
}

# Synopsis: Execute Build tasks (avoiding setup if possible)
task Build {

}

# Synopsis: Execute build tasks from a new environment
task Rebuild Clean, Register, Reinstall, Package, Build

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
