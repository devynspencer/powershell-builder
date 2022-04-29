# Synopsis: Unregister repositories and package sources
task UnregisterPublicRepo {
    Write-Build Cyan 'Unregistering public PowerShellGet repositories and package sources ...'

    foreach ($Registered in @($Config.RepositoryName, $Config.StagingRepositoryName)) {
        Unregister-PSRepository -Name $Registered -ErrorAction 0 | Out-Null
        Unregister-PackageSource -Source $Registered -ErrorAction 0 | Out-Null
    }
}

# Synopsis: Register repositories and package sources
task RegisterPublicRepo UnregisterPublicRepo, {
    Write-Build Cyan 'Registering local PowerShellGet repositories and package sources ...'

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

# Synopsis: Register internal PSRepository
task RegisterOrgRepo {
    $RegisterParams = @{
        Name = $BuilderEnv.Publish.OrgRepo.Name
        SourceLocation = $BuilderEnv.Publish.OrgRepo.SourceUri
        PublishLocation = $BuilderEnv.Publish.OrgRepo.PublishUri
        InstallationPolicy = 'Trusted'
    }

    Register-PSRepository @RegisterParams
}

# Synopsis: Remove internal PSRepository
task UnregisterOrgRepo {
    Unregister-PSRepository -Name $BuilderEnv.Publish.OrgRepo.Name
}

# Synopsis: Query internal package registry index
task ShowOrgPackageIndex {
    Write-Build Cyan "Retrieving registry index from [$($BuilderEnv.Publish.OrgRepo.SourceUri)] ..."

    $RestParams = @{
        Uri = $BuilderEnv.Publish.OrgRepo.SourceUri
    }

    $Response = Invoke-RestMethod @RestParams
    $Response.resources | Write-Build DarkCyan
}

# Synopsis: List all packages hosted on internal package registry
task ShowOrgPackages {
    Write-Build Cyan "Retrieving packages from [$($BuilderEnv.Publish.OrgRepo.SourceUri)] ..."

    $RestParams = @{
        Uri = $BuilderEnv.Publish.OrgRepo.SearchUri
    }

    $Response = Invoke-RestMethod @RestParams

    foreach ($Package in $Response.data) {
        $Package.versions.foreach({ Write-Build DarkCyan ('{0}:{1}' -f $Package.id, $_.version) })
    }
}

# Synopsis: Unregister all PSRepositories
task Unregister UnregisterOrgRepo

# Synopsis: Register all PSRepositories
task Register RegisterOrgRepo
