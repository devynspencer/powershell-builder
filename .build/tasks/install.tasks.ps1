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
    Write-Build Cyan 'Installing module dependencies specified in module manifest ...'

    foreach ($Entry in $Manifest.RequiredModules) {
        $Current = $Manifest.RequiredModules.IndexOf($Entry)

        Write-Build Cyan "Installing module [$Current of $($Manifest.RequiredModules.Count)]"

        # TODO: Add support for mixed entries in RequiredModules

        # This task assumes each entry in RequiredModules is specified as a hashtable, but
        # the documentation indicates entries containing only the module name (as a string) can be
        # mixed with entries specifying version information (as a hashtable)
        $InstallParams = @{
            Name = $Entry.ModuleName
            Force = $true
        }

        # Build up some ugly & redundant hashtables as a workaround:
        # RequiredModules section in module manifest uses ModuleName to identify
        # modules but Install-Module uses Name
        if ($Entry.ContainsKey('RequiredVersion')) {
            $InstallParams.RequiredVersion = $Entry.RequiredVersion
        }

        # Oh, also MinimumVersion is used instead of ModuleVersion
        elseif ($Entry.ContainsKey('ModuleVersion')) {
            $InstallParams.MinimumVersion = $Entry.ModuleVersion
        }

        else {
            throw "Entry $(ConvertTo-Json $Entry -Compress) in RequiredModules is missing version info"
        }

        Install-Module @InstallParams
    }

    Install-Package NuGet
}

# Synopsis: Remove and reinstall all project module dependencies
task Reinstall {
    Write-Build Cyan 'Uninstalling module dependencies ...'

    foreach ($Entry in $Manifest.RequiredModules) {
        # TODO: Add support for mixed entries in RequiredModules

        # This task assumes each entry in RequiredModules is specified as a hashtable, but
        # the documentation indicates entries containing only the module name (as a string) can be
        # mixed with entries specifying version information (as a hashtable)
        $UninstallParams = @{
            Name = $Entry.ModuleName
            Force = $true
        }

        # Build up some ugly & redundant hashtables as a workaround:
        # RequiredModules section in module manifest uses ModuleName to identify
        # modules but Install-Module uses Name
        if ($Entry.ContainsKey('RequiredVersion')) {
            $UninstallParams.RequiredVersion = $Entry.RequiredVersion
        }

        # Oh, also MinimumVersion is used instead of ModuleVersion
        elseif ($Entry.ContainsKey('ModuleVersion')) {
            $UninstallParams.MinimumVersion = $Entry.ModuleVersion
        }

        else {
            throw "Entry $(ConvertTo-Json $Entry -Compress) in RequiredModules is missing version info"
        }

        Uninstall-Module @UninstallParams
    }
}, Install

# TODO: should there be a step to re-import modules that have been reinstalled?
