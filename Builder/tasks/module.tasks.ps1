# Synopsis: Reapply the latest version of the module template
task RebuildModule {
    Write-Build DarkCyan "Rebuild module [$($BuilderEnv.General.ModuleName)] from Plaster template"

    $Manifest = Import-PowerShellDataFile -Path $BuilderEnv.General.ModuleManifestPath

    $RebuildParams = @{
        ModuleName = $BuilderEnv.General.ModuleName
        Destination = $BuilderEnv.General.ProjectRoot
        Version = $BuilderEnv.General.ModuleVersion
        CompanyName = $Manifest.CompanyName
        PowerShellVersion = $Manifest.PowerShellVersion
        Author = $Manifest.Author
        Description = $Manifest.Description
        TemplateName = 'BasicModule'
    }

    Build-Module @RebuildParams
}
