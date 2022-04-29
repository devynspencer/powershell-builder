# Synopsis: Display project directory structure
task ShowProjectDirTree {
    exec { tree /f /a }
}

# Synopsis: Display local staging directory structure
task ShowLocalStagingDirTree {
    Set-Location -Path $BuilderEnv.Publish.LocalStagingRepo.SourcePath
    exec { tree /f /a }
}

# Synopsis: Display environment configuration data
task ShowEnvironment {
    Write-Build Magenta "`nDebug [BuildEnv?]: build environment"
    $EnvironmentVariables = @(
        'GITHUB_USERNAME'
        'GITHUB_PACKAGES_TOKEN'
    )

    foreach ($Var in $EnvironmentVariables) {
        $VarPath = Join-Path -Path 'Env:\' -ChildPath $Var

        if (Test-Path -Path $VarPath) {
            Write-Build DarkCyan "[$Var]: $((Get-Item -Path $VarPath).Value)"
        }

        else {
            Write-Build Red "[$Var]:"
        }
    }
}

# Synopsis: Display all logs
task ShowLogs {

}

# Synopsis: Execute basic debug tasks
task Debug ShowProjectDirTree, ShowLocalStagingDirTree, ShowEnvironment
