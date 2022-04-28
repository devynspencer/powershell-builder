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

task Init InitTemp
