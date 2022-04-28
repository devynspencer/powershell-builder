# Synopsis: Publish module to local staging repository
task Package Clean, {
    $script:PackagePath = Join-Path -Path $BuildRoot -ChildPath $Config.StagingPath
    $script:PackageFileName = @($ModuleName, $Manifest.ModuleVersion, 'nupkg') -join '.'

    # Staging locally allows non-standard attributes to be added to the nuspec,
    # and is currently necessary to publish to GitHub Packages
    # - See @cdhunt's response here: https://github.com/PowerShell/PowerShellGet/issues/163
    $PublishParams = @{
        Repository = $Config.StagingRepositoryName
        Path = "$BuildRoot\$ModuleName"
        NuGetApiKey = $Config.RegistryToken
    }

    Publish-Module @PublishParams
    Write-Build Cyan "Building package [$PackageFileName] in [$($Config.StagingPath)]"
}
