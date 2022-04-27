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

# Synopsis: Display all logs
task ShowLogs ShowPackageLog

# Synopsis: Display packaging log
task ShowPackageLog {
    Write-Build Magenta "Displaying logs from [$PackageLogFilePath]"
    Write-Build DarkMagenta (Get-Content -Raw $PackageLogFilePath)
}

task Debug ShowDirTree, ShowEnvironment, ShowLastLogs
