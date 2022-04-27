# Synopsis: Display directory structure
task ShowDirTree {
    exec { tree /f /a }
}

# Synopsis: Display environment configuration data
task ShowEnvironment {
    Write-Build Magenta ($Manifest | ConvertTo-Json)
    Write-Build Cyan ($Config | ConvertTo-Json)
}

# Synopsis: Watch build logs
task ShowLastLogs {

}

task Debug ShowDirTree, ShowEnvironment, ShowLastLogs
