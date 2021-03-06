# Synopsis: Purge files from temp directories
task CleanTemp {
    $TempDir = [IO.Path]::Combine($BuilderEnv.General.ProjectRoot, 'temp')

    $Subdirs = @(
        $BuilderEnv.Build.OutDir
        $BuilderEnv.Build.LogDir
        $BuilderEnv.Build.ReportDir
    )

    Write-Build -Color Cyan "Purging files from [$TempDir]"
    $Subdirs.foreach({ remove "$_\*" })
}

# Synopsis: Purge files from local staging directory
task CleanLocalStaging {
    $LocalStagingPath = $BuilderEnv.Publish.LocalStagingRepo.SourcePath
    Write-Build -Color Cyan "Purging files from [$LocalStagingPath]"

    # No need to recurse in this case, safety first!
    $StagedParams = @{
        Path = $LocalStagingPath
        Filter = "$($BuilderEnv.General.ModuleName)*.nupkg"
        File = $true
    }

    $StagedFiles = @(Get-ChildItem @StagedParams)

    Write-Build Cyan "Found $($StagedFiles.Count) files"

    foreach ($File in $StagedFiles) {
        Write-Build DarkCyan "Removing [$($File.Name)]"
        remove $File.FullName
    }
}

# Synopsis: Clean all build artifacts
task Clean CleanTemp, CleanLocalStaging
