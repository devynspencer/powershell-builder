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
