# Synopsis: Purge files from temp directories
task Clean {
    Write-Build -Color Cyan 'Performing cleanup activities'

    'output', 'files', 'logs', 'reports' | ForEach-Object { remove "$BuildRoot\temp\$_\*" }
}
