# Synopsis: Publish to internal package registry
task PublishOrg {
    $PublishParams = @{
        Path = $BuilderEnv.General.SrcRootDir
        NuGetApiKey = $BuilderEnv.Publish.OrgRepo.ApiKey
        Repository = $BuilderEnv.Publish.OrgRepo.Name
    }

    Publish-Module @PublishParams
}

# Synopsis: Publish to all package registries
task Publish PublishOrg
