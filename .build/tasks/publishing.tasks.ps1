# Synopsis: Perform all publishing tasks
task Publish Package, {
    $script:RepositoryBaseUri = "https://github.com/$($Config.RegistryUser)"
    $script:RepositoryUri = "$RepositoryBaseUri/$($Config.ProjectName)"
    $script:PackageFilePath = Join-Path -Path $PackagePath -ChildPath $PackageFileName

    Write-Build Cyan "Deploying package [$PackageFileName] to [$RepositoryUri]"

    $PushParams = @{
        FilePath = 'gpr.exe'
        ArgumentList = @(
            'push',
            '--api-key',
            $Config.RegistryToken,
            '--repository',
            $RepositoryUri,
            $PackageFilePath
        )
    }

    Start-Process @PushParams -Wait -NoNewWindow -WorkingDirectory $Config.StagingPath
}
