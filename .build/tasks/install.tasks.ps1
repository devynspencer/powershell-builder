# Synopsis: Unregister repositories and package sources
task Unregister {
    Write-Build Cyan 'Unregistering PowerShellGet repositories and package sources ...'

    foreach ($Registered in @($Config.RepositoryName, $Config.StagingRepositoryName)) {
        Unregister-PSRepository -Name $Registered -ErrorAction 0 | Out-Null
        Unregister-PackageSource -Source $Registered -ErrorAction 0 | Out-Null
    }
}

# Synopsis: Register repositories and package sources
task Register Unregister, Credentials, {
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
task Install {
    $Config.ProjectModules.foreach({ Install-Module @_ })

    Install-Package NuGet
}

# Synopsis: Remove and reinstall all project module dependencies
task Reinstall {
    $Config.ProjectModules.foreach({ Uninstall-Module @_ })
}, Install
