# Synopsis: Publish to local staging package registry
task PublishLocalStaging CleanLocalStaging, RegisterLocalStagingRepo, {
    $PublishParams = @{
        Path = $BuilderEnv.General.SrcRootDir
        Repository = $BuilderEnv.Publish.LocalStagingRepo.Name
    }

    Publish-Module @PublishParams
}

# Synopsis: Publish to internal package registry
task PublishOrg RegisterOrgRepo, {
    $PublishParams = @{
        Path = $BuilderEnv.General.SrcRootDir
        NuGetApiKey = $BuilderEnv.Publish.OrgRepo.ApiKey
        Repository = $BuilderEnv.Publish.OrgRepo.Name
    }

    Publish-Module @PublishParams
}

# Synopsis: Publish to all package registries
task Publish PublishOrg, PublishLocalStaging
