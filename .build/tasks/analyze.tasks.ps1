task Analyze {
    Write-Build Cyan "Performing static code analysis of [$BuildRoot\$ModuleName]"

    $AnalyzerParams = @{
        Path = "$BuildRoot\$ModuleName"
        Settings = "$BuildRoot\ScriptAnalyzerSettings.psd1"
        Recurse = $true
    }

    # Forcing this into an array to fix issues when a single result is returned
    $AnalysisResult = @(Invoke-ScriptAnalyzer @AnalyzerParams)

    if ($AnalysisResult) {
        Write-Build Cyan "Analysis complete! Found [$($AnalysisResult.Count)] issues:"

        # Generate a basic report on results of analysis
        $Warnings = @($AnalysisResult | Where-Object { $_.Severity -eq 'Warning' })
        $Errors = @($AnalysisResult | Where-Object { $_.Severity -eq 'Error' })

        Write-Build Yellow "`n[$($Warnings.Count)] Warnings:"
        $Warnings.foreach({ Write-Build Yellow ('Rule "{0}" at {1}:{2}' -f $_.RuleName, $_.ScriptName, $_.Line) })

        Write-Build Red "`n[$($Errors.Count)] Errors:"
        $Errors.foreach({ Write-Build Red ('Rule "{0}" at {1}:{2}' -f $_.RuleName, $_.ScriptName, $_.Line) })

        # Save report
        Write-Build Cyan "Saving report to [$($Config.ScriptAnalyzer.ReportFilePath)]"

        # TODO: replace with nunit support or whatever
        $AnalysisResult | Export-Clixml -Path $Config.ScriptAnalyzer.ReportFilePath -Force

        # Stop build on errors
        if ($Errors) {
            throw "ScriptAnalyzer found [$($Errors.Count)] errors, halting build"
        }
    }

    else {
        Write-Build Cyan 'Analysis complete! No issues found.'
    }
}
