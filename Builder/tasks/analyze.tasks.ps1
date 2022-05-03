task Analyze {
    Write-Build Cyan "Performing analysis of [$($BuilderEnv.General.ModuleName):$($BuilderEnv.General.ModuleVersion)]"

    $AnalyzerParams = @{
        Path = $BuilderEnv.General.SrcRootDir
        Settings = $BuilderEnv.Test.ScriptAnalysis.SettingsPath
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
        $ReportId = Get-Date -Format FileDateTime
        $AnalysisResultsPath = [IO.Path]::Combine($BuilderEnv.General.ReportDir, "PSScriptAnalyzer.$ReportId.xml")

        Write-Build Cyan "Saving report to [$AnalysisResultsPath]"

        # TODO: replace with nunit support or whatever
        $AnalysisResult | Export-Clixml -Path $AnalysisResultsPath -Force

        # Stop build on errors
        if ($Errors) {
            throw "ScriptAnalyzer found [$($Errors.Count)] errors, halting build"
        }
    }

    else {
        Write-Build Cyan 'Analysis complete! No issues found.'
    }
}
