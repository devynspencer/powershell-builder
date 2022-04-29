# Synopsis: Register local repositories and package sources
task RegisterLocalStagingRepo UnregisterLocalStagingRepo, {
    Write-Build Cyan 'Registering local staging PowerShellGet repositories and package sources ...'

    # Staging locally allows non-standard attributes to be added to the nuspec,
    # and is currently necessary to publish to GitHub Packages
    # - See @cdhunt's response here: https://github.com/PowerShell/PowerShellGet/issues/163
    $StagingParams = @{
        Name = $BuilderEnv.Publish.LocalStagingRepo.Name
        SourceLocation = $BuilderEnv.Publish.LocalStagingRepo.SourcePath
    }

    Register-PSRepository @StagingParams -InstallationPolicy 'Trusted'
}

task UnregisterLocalStagingRepo {
    Write-Build Cyan 'Unregistering local staging PowerShellGet repositories and package sources ...'
    Unregister-PSRepository -Name $BuilderEnv.Publish.LocalStagingRepo.Name
}

# Synopsis: Register internal PSRepository
task RegisterOrgRepo UnregisterOrgRepo, {
    Write-Build Cyan 'Registering internal PowerShellGet repositories and package sources ...'

    $RegisterParams = @{
        Name = $BuilderEnv.Publish.OrgRepo.Name
        SourceLocation = $BuilderEnv.Publish.OrgRepo.SourceUri
        PublishLocation = $BuilderEnv.Publish.OrgRepo.PublishUri
    }

    Register-PSRepository @RegisterParams -InstallationPolicy 'Trusted'
}

# Synopsis: Remove internal PSRepository
task UnregisterOrgRepo {
    Write-Build Cyan 'Unregistering internal PowerShellGet repositories and package sources ...'
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
task Unregister UnregisterOrgRepo, UnregisterLocalStagingRepo

# Synopsis: Register all PSRepositories
task Register RegisterOrgRepo, RegisterLocalStagingRepo
