task InitTemp {
    $NewDirParams = @{
        Force = $true
        ErrorAction = 'SilentlyContinue'
        ItemType = 'Directory'
    }

    $null = New-Item @NewDirParams -Path $BuilderEnv.Build.OutDir
    $null = New-Item @NewDirParams -Path $BuilderEnv.Build.LogDir
    $null = New-Item @NewDirParams -Path $BuilderEnv.Build.ReportDir
}

task InitLocalStagingDir {
    $NewDirParams = @{
        Force = $true
        ErrorAction = 'SilentlyContinue'
        ItemType = 'Directory'
        Path = $BuilderEnv.Publish.LocalStagingRepo.SourcePath
    }

    $null = New-Item @NewDirParams
}

task Init InitTemp, InitLocalStagingDir
