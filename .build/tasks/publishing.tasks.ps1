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
