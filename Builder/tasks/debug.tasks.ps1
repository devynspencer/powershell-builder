# Synopsis: Display directory structure
task ShowDirTree {
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
task Debug ShowDirTree, ShowEnvironment
